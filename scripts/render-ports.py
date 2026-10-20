#!/usr/bin/env python3
"""Render the VSCode and Zed configs from the canonical spec + templates.

    python3 scripts/render-ports.py            # render everything
    python3 scripts/render-ports.py --check    # show what would change
    python3 scripts/render-ports.py --dry-run  # print, do not write

Inputs (all in this repo):
    keymaps.json            canonical keymap spec
    ports/vscode-settings.jsonc
    ports/vscode-keybindings.json
    ports/zed-settings.json
    ports/zed-keymap.json

Outputs:
    ~/.config/Code/User/settings.json
    ~/.config/Code/User/keybindings.json
    ~/.config/zed/settings.json
    ~/.config/zed/keymap.json

Every file is validated (JSON parse) before it is written, and the previous
version is kept next to it as <file>.prev.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
PORTS = REPO / "ports"
SPEC = REPO / "keymaps.json"
CONFIG = Path(sys.argv[0]).resolve().parent  # placeholder, replaced below
CONFIG = Path.home() / ".config"

VSCODE_ESCAPES = {"ctrl": "C", "shift": "S", "alt": "A", "cmd": "D"}

TARGETS = {
    "vscode-settings": (PORTS / "vscode-settings.jsonc", CONFIG / "Code/User/settings.json"),
    "vscode-keybindings": (PORTS / "vscode-keybindings.json", CONFIG / "Code/User/keybindings.json"),
    "zed-settings": (PORTS / "zed-settings.json", CONFIG / "zed/settings.json"),
    "zed-keymap": (PORTS / "zed-keymap.json", CONFIG / "zed/keymap.json"),
}


def load_spec() -> list[dict]:
    spec = json.loads(SPEC.read_text(encoding="utf-8"))
    return [m for group in spec["groups"] for m in group["maps"]]


def vscode_before(key: str) -> list[str]:
    tokens = key.split(" ")
    out: list[str] = []
    for index, token in enumerate(tokens):
        if index == 0 and token == "space":
            out.append("<leader>")
            continue
        if "+" in token:
            parts = token.split("+")
            mods = "".join(VSCODE_ESCAPES.get(p, p.upper()) for p in parts[:-1])
            out.append(f"<{mods}-{parts[-1]}>")
            continue
        out.append(token)
    return out


def render_vscode_bindings(entries: list[dict]) -> str:
    blocks = []
    for entry in entries:
        vs = entry.get("vscode")
        if not vs:
            continue
        block = {
            "before": vscode_before(vs["key"]),
            "commands": [vs["command"]],
            "silent": True,
            "comment": entry["action"],
        }
        text = json.dumps(block, indent=2)
        text = "\n".join("    " + line for line in text.splitlines())
        blocks.append(text)
    return ",\n".join(blocks)


def render_zed_bindings(entries: list[dict]) -> str:
    lines = []
    for entry in entries:
        zd = entry.get("zed")
        if not zd:
            continue
        lines.append(f'      "{zd["key"]}": "{zd["action"]}"')
    return ",\n".join(lines)


def build(entries: list[dict]) -> dict[Path, str]:
    rendered: dict[Path, str] = {}
    for name, (template, target) in TARGETS.items():
        text = template.read_text(encoding="utf-8")
        if name == "vscode-settings":
            text = text.replace("__VIM_NORMAL__", render_vscode_bindings(entries))
        elif name == "zed-keymap":
            text = text.replace("__VIM_BINDINGS__", render_zed_bindings(entries))
        rendered[target] = text
    return rendered


def validate(path: Path, text: str) -> None:
    """Fail loudly on malformed output before it reaches the editor."""
    if "Code" in path.parts:
        json.loads(strip_jsonc(text))  # VSCode settings are JSONC
    else:
        json.loads(text)  # Zed reads strict JSON


def strip_jsonc(text: str) -> str:
    """Turn JSONC into strict JSON: drop comments and trailing commas."""
    out: list[str] = []
    in_string = False
    i = 0
    n = len(text)
    while i < n:
        ch = text[i]
        if in_string:
            out.append(ch)
            if ch == "\\" and i + 1 < n:
                out.append(text[i + 1])
                i += 2
                continue
            if ch == '"':
                in_string = False
            i += 1
            continue
        if ch == '"':
            in_string = True
            out.append(ch)
            i += 1
            continue
        if text[i : i + 2] == "//":
            while i < n and text[i] != "\n":
                i += 1
            continue
        if text[i : i + 2] == "/*":
            end = text.find("*/", i)
            i = n if end == -1 else end + 2
            continue
        if ch == ",":
            j = i + 1
            while j < n:
                if text[j] in " \t\r\n":
                    j += 1
                    continue
                if text[j : j + 2] == "//":
                    while j < n and text[j] != "\n":
                        j += 1
                    continue
                if text[j : j + 2] == "/*":
                    end = text.find("*/", j)
                    j = n if end == -1 else end + 2
                    continue
                break
            if j < n and text[j] in "}]":
                i += 1  # trailing comma: drop it
                continue
        out.append(ch)
        i += 1
    return "".join(out)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="report differences, change nothing")
    parser.add_argument("--dry-run", action="store_true", help="print the rendered files")
    args = parser.parse_args()

    entries = load_spec()
    rendered = build(entries)

    changed = []
    for target, text in rendered.items():
        validate(target, text)
        current = target.read_text(encoding="utf-8") if target.exists() else None
        if current != text:
            changed.append(target)

    if args.dry_run:
        for target, text in rendered.items():
            print(f"===== {target} =====")
            print(text)
        return 0

    if args.check:
        if changed:
            print("out of date:")
            for target in changed:
                print(f"  - {target}")
            return 1
        print("all ports are up to date")
        return 0

    for target, text in rendered.items():
        target.parent.mkdir(parents=True, exist_ok=True)
        mode = None
        if target.exists():
            shutil.copy2(target, target.with_suffix(target.suffix + ".prev"))
            mode = target.stat().st_mode
        target.write_text(text, encoding="utf-8")
        if mode is not None:
            os.chmod(target, mode & 0o7777)  # keep the original permissions
        print(f"wrote {target}")

    print()
    print(f"{len(changed)} of {len(rendered)} files changed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
