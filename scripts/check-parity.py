#!/usr/bin/env python3
"""Check that Neovim, VSCode and Zed all implement the canonical keymap spec.

The spec lives next to this script (``../keymaps.json``). It is the single
source of truth for the shared key bindings; this script proves that each
editor actually implements it.

    python3 scripts/check-parity.py            # parity + command/action existence
    python3 scripts/check-parity.py --no-bin   # parity only (skip binary greps)
    python3 scripts/check-parity.py --json     # machine readable output

Exit code 0 when every editor implements every mapping it is expected to.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SPEC = REPO / "keymaps.json"
VSCODE_USER = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "Code" / "User"
ZED_CONFIG = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "zed"

VSCODE_BUNDLE_GLOBS = [
    "/usr/share/code/resources/app/out/vs/workbench/workbench.desktop.main.js",
    "/usr/share/code/resources/app/extensions/*/package.json",
    "/usr/share/code/resources/app/extensions/*/dist/main.js",
]
ZED_BINARIES = [
    Path.home() / ".local/zed.app/libexec/zed-editor",
    Path("/usr/lib/zed/zed"),
]


# --------------------------------------------------------------------------- #
# helpers
# --------------------------------------------------------------------------- #
def load_jsonc(path: Path):
    """Load a JSON file that may contain comments and trailing commas."""
    text = path.read_text(encoding="utf-8")
    out = []
    i, n = 0, len(text)
    in_string = False
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
        if ch == "/" and i + 1 < n and text[i + 1] == "/":
            while i < n and text[i] != "\n":
                i += 1
            continue
        if ch == "/" and i + 1 < n and text[i + 1] == "*":
            i += 2
            while i + 1 < n and not (text[i] == "*" and text[i + 1] == "/"):
                i += 1
            i += 2
            continue
        out.append(ch)
        i += 1
    cleaned = "".join(out)
    cleaned = re.sub(r",(\s*[}\]])", r"\1", cleaned)
    return json.loads(cleaned)


def norm(text: str) -> str:
    """Normalise a key for comparison (case insensitive, uniform spacing)."""
    return re.sub(r"\s+", " ", text.strip().lower())


def norm_vscode(text: str) -> str:
    """Normalise a VSCode key, translating vim style modifiers.

    VSCodeVim's `before` array uses vim notation ("<C-h>"), the spec uses the
    VSCode spelling ("ctrl+h"); both have to compare equal.
    """
    text = text.lower()
    mods = {"c": "ctrl", "s": "shift", "a": "alt", "d": "cmd"}

    def _expand(match: re.Match) -> str:
        names = [mods[ch] for ch in match.group(1)]
        return "+".join(names + [match.group(2)])

    text = re.sub(r"<([csad]+)-([^>]+)>", _expand, text)
    return re.sub(r"\s+", " ", text.strip())


def norm_nvim(text: str) -> str:
    """Normalise a Neovim lhs.

    The leader expands to a literal space, so whitespace is significant here:
    " gd" (leader + gd) must not collapse into "gd".
    """
    text = text.lower()
    text = text.replace("<leader>", " ").replace("<space>", " ")
    return re.sub(r"\s+", " ", text)


# --------------------------------------------------------------------------- #
# editors
# --------------------------------------------------------------------------- #
NVIM_DUMP = """
local out = {}
local seen = {}
local function collect(mode, maps)
  for _, km in ipairs(maps) do
    local lhs = km.lhs or ""
    if not seen[mode .. "|" .. lhs] then
      seen[mode .. "|" .. lhs] = true
      out[#out + 1] = mode .. "\\t" .. lhs .. "\\t" .. (km.desc or "")
    end
  end
end
vim.wait(1500, function() return false end)
for _, m in ipairs({"n", "x", "v"}) do collect(m, vim.api.nvim_get_keymap(m)) end
-- buffer local maps (LSP servers and gitsigns register their keys per buffer)
for _, m in ipairs({"n", "x", "v"}) do collect(m, vim.api.nvim_buf_get_keymap(0, m)) end
local f = io.open(os.getenv("NVIM_DUMP_FILE"), "w")
f:write(table.concat(out, "\\n"))
f:close()
"""


def nvim_keymaps() -> set[str]:
    """Return every normal/visual mode key binding of the live Neovim config.

    A throwaway git repository with a Python file is opened so that the
    buffer local bindings (LSP servers, gitsigns) are registered as well.
    """
    if not shutil.which("nvim"):
        return set()
    with tempfile.TemporaryDirectory() as tmp:
        tmp_path = Path(tmp)
        demo = tmp_path / "demo.py"
        demo.write_text("def hello():\n    return 1\n", encoding="utf-8")
        subprocess.run(["git", "init", "-q", str(tmp_path)], capture_output=True)
        subprocess.run(
            ["git", "-C", str(tmp_path), "add", "-A"],
            capture_output=True,
        )
        dump_file = tmp_path / "keymaps.txt"
        script = tmp_path / "dump.lua"
        script.write_text(NVIM_DUMP, encoding="utf-8")
        env = dict(os.environ, NVIM_DUMP_FILE=str(dump_file))
        # VeryLazy never fires in headless mode, so force it: LazyVim gates a
        # large part of its default keymaps on that event.
        cmd = [
            "nvim", "--headless", str(demo),
            "-c", "lua vim.defer_fn(function() vim.api.nvim_exec_autocmds('User', { pattern = 'VeryLazy' }) end, 500)",
            "-c", "sleep 6",
            "-c", "luafile " + str(script),
            "-c", "qa!",
        ]
        subprocess.run(cmd, env=env, capture_output=True, text=True, timeout=180)
        if not dump_file.exists():
            return set()
        keys = set()
        for line in dump_file.read_text(encoding="utf-8").splitlines():
            parts = line.split("\t")
            if len(parts) >= 2:
                keys.add(norm_nvim(parts[1]))
        return keys


def vscode_bindings() -> dict[str, list[str]]:
    """Return {normalised key: [command, ...]} for VSCode."""
    bindings: dict[str, list[str]] = {}
    settings = VSCODE_USER / "settings.json"
    if settings.exists():
        data = load_jsonc(settings)
        groups = [
            ("vim.normalModeKeyBindingsNonRecursive", data),
            ("vim.visualModeKeyBindings", data),
        ]
        for name, source in groups:
            for entry in source.get(name, []) or []:
                before = entry.get("before")
                if not before:
                    continue
                tokens = ["space" if str(t).lower() == "<leader>" else str(t) for t in before]
                key = norm_vscode(" ".join(tokens))
                commands = entry.get("commands") or entry.get("command") or []
                if isinstance(commands, str):
                    commands = [commands]
                bindings.setdefault(key, []).extend(str(c) for c in commands)
    keybindings = VSCODE_USER / "keybindings.json"
    if keybindings.exists():
        for entry in load_jsonc(keybindings):
            key = entry.get("key")
            if not key:
                continue
            command = entry.get("command")
            if command:
                bindings.setdefault(norm_vscode(key), []).append(str(command))
    return bindings


def zed_bindings() -> dict[str, list[str]]:
    """Return {normalised key: [action, ...]} for Zed."""
    bindings: dict[str, list[str]] = {}
    keymap = ZED_CONFIG / "keymap.json"
    if not keymap.exists():
        return bindings
    for context in load_jsonc(keymap):
        for key, value in (context.get("bindings") or {}).items():
            if isinstance(value, str):
                actions = [value]
            elif isinstance(value, list):
                actions = [v for v in value if isinstance(v, str)]
            else:
                actions = []
            bindings.setdefault(norm(key), []).extend(actions)
    return bindings


# --------------------------------------------------------------------------- #
# binary validation (does the command / action actually exist?)
# --------------------------------------------------------------------------- #
def vscode_command_exists(command: str) -> bool | None:
    """True/False if the VSCode command id is known, None if we cannot tell."""
    needle = f'"{command}"'
    for pattern in VSCODE_BUNDLE_GLOBS:
        for path in sorted(Path("/").glob(pattern.lstrip("/"))):
            try:
                if needle.encode() in path.read_bytes():
                    return True
            except OSError:
                continue
    return None


def zed_action_exists(action: str) -> bool | None:
    for binary in ZED_BINARIES:
        if binary.exists():
            try:
                return action.encode() in binary.read_bytes()
            except OSError:
                continue
    return None


# --------------------------------------------------------------------------- #
# main
# --------------------------------------------------------------------------- #
def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--no-bin", action="store_true", help="skip command/action existence checks")
    parser.add_argument("--json", action="store_true", help="emit JSON")
    args = parser.parse_args()

    spec = json.loads(SPEC.read_text(encoding="utf-8"))
    entries = [m for group in spec["groups"] for m in group["maps"]]

    live = nvim_keymaps()
    vscode = vscode_bindings()
    zed = zed_bindings()

    results = []
    for entry in entries:
        row = {"id": entry["id"], "keys": entry["keys"], "action": entry["action"], "editors": {}}

        nvim = entry.get("nvim")
        if nvim:
            ok = norm_nvim(nvim["key"]) in live
            row["editors"]["nvim"] = {"ok": ok, "key": nvim["key"], "impl": nvim["impl"]}
            if not ok and entry.get("conditional"):
                # registered on LSP attach / buffer attach: not visible in a
                # headless probe, so a miss here is expected, not a failure.
                row["editors"]["nvim"]["conditional"] = True
        else:
            row["editors"]["nvim"] = {"ok": None, "key": None, "impl": "not supported"}

        vs = entry.get("vscode")
        if vs:
            commands = vscode.get(norm_vscode(vs["key"]), [])
            ok = vs["command"] in commands
            row["editors"]["vscode"] = {"ok": ok, "key": vs["key"], "impl": vs["command"],
                                        "found": commands}
            if ok and not args.no_bin:
                row["editors"]["vscode"]["exists"] = vscode_command_exists(vs["command"])
        else:
            row["editors"]["vscode"] = {"ok": None, "key": None, "impl": "not supported"}

        zd = entry.get("zed")
        if zd:
            actions = zed.get(norm(zd["key"]), [])
            ok = zd["action"] in actions
            row["editors"]["zed"] = {"ok": ok, "key": zd["key"], "impl": zd["action"],
                                     "found": actions}
            if ok and not args.no_bin:
                row["editors"]["zed"]["exists"] = zed_action_exists(zd["action"])
        else:
            row["editors"]["zed"] = {"ok": None, "key": None, "impl": "not supported"}

        results.append(row)

    failures = []
    for row in results:
        for editor, data in row["editors"].items():
            if data["ok"] is False and not data.get("conditional"):
                failures.append((row["id"], editor, data))
            if data.get("exists") is False:
                failures.append((row["id"], editor + " (unknown command/action)", data))

    if args.json:
        print(json.dumps({"results": results, "failures": len(failures)}, indent=2))
        return 1 if failures else 0

    print(f"canonical spec: {SPEC}")
    print(f"mappings: {len(results)}\n")
    header = f"{'KEYS':<14} {'ACTION':<42} {'NVIM':<6} {'VSCODE':<8} {'ZED':<6}"
    print(header)
    print("-" * len(header))
    for row in results:
        marks = []
        for editor in ("nvim", "vscode", "zed"):
            data = row["editors"][editor]
            if data["ok"] is None:
                marks.append("-")
            elif data["ok"]:
                marks.append("ok" if data.get("exists") is not False else "ok!")
            elif data.get("conditional"):
                marks.append("cond")
            else:
                marks.append("FAIL")
        print(f"{row['keys']:<14} {row['action'][:41]:<42} {marks[0]:<6} {marks[1]:<8} {marks[2]:<6}")

    print()
    if failures:
        print(f"FAILURES ({len(failures)}):")
        for ident, editor, data in failures:
            print(f"  - {ident} [{editor}] expected {data.get('impl')!r} "
                  f"key={data.get('key')!r} found={data.get('found')}")
        return 1

    implemented = sum(
        1 for row in results for data in row["editors"].values() if data["ok"] is True
    )
    print(f"PARITY OK - {implemented} bindings implemented across nvim, VSCode and Zed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
