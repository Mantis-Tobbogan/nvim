#!/usr/bin/env python3
"""Generate the VSCode and Zed key bindings from the canonical spec.

The canonical spec is ``keymaps.json``. This script renders it into the two
foreign formats so the ports can never drift from the source of truth:

    python3 scripts/port-keymaps.py vscode   # -> vim.normalModeKeyBindingsNonRecursive
    python3 scripts/port-keymaps.py zed      # -> {"key": "action", ...}
    python3 scripts/port-keymaps.py all      # both, with section markers

Re-run it whenever keymaps.json changes and paste the output into
~/.config/Code/User/settings.json and ~/.config/zed/keymap.json.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SPEC = REPO / "keymaps.json"

VSCODE_ESCAPES = {"ctrl": "C", "shift": "S", "alt": "A", "cmd": "D"}


def load_spec() -> list[dict]:
    spec = json.loads(SPEC.read_text(encoding="utf-8"))
    return [m for group in spec["groups"] for m in group["maps"]]


def vscode_before(key: str) -> list[str]:
    """'space f g' -> ['<leader>', 'f', 'g'], 'ctrl+h' -> ['<C-h>']."""
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


def render_vscode(entries: list[dict]) -> str:
    blocks = []
    for entry in entries:
        vs = entry.get("vscode")
        if not vs:
            continue
        before = vscode_before(vs["key"])
        block = {
            "before": before,
            "commands": [vs["command"]],
            "silent": True,
            "comment": entry["action"],
        }
        blocks.append(block)
    body = ",\n".join(
        "    " + json.dumps(block, indent=4).replace("\n", "\n    ").lstrip() for block in blocks
    )
    return body


def render_zed(entries: list[dict]) -> str:
    lines = []
    for entry in entries:
        zd = entry.get("zed")
        if not zd:
            continue
        lines.append(f'      "{zd["key"]}": "{zd["action"]}",  // {entry["action"]}')
    return "\n".join(lines)


def main() -> int:
    mode = sys.argv[1] if len(sys.argv) > 1 else "all"
    entries = load_spec()
    if mode in ("vscode", "all"):
        print("=== VSCODE (vim.normalModeKeyBindingsNonRecursive) ===")
        print(render_vscode(entries))
    if mode in ("zed", "all"):
        print()
        print("=== ZED (context: VimControl && !menu) ===")
        print(render_zed(entries))
    return 0


if __name__ == "__main__":
    sys.exit(main())
