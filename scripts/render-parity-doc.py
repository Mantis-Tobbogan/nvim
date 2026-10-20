#!/usr/bin/env python3
"""Render docs/EDITOR-PARITY.md from the canonical spec.

    python3 scripts/render-parity-doc.py
"""

from __future__ import annotations

import json
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SPEC = REPO / "keymaps.json"
DOC = REPO / "docs" / "EDITOR-PARITY.md"


def cell(value: str | None) -> str:
    if not value:
        return "—"
    return f"`{value}`"


def main() -> int:
    spec = json.loads(SPEC.read_text(encoding="utf-8"))
    lines: list[str] = []
    lines.append("# Editor parity matrix")
    lines.append("")
    lines.append("Generated from [`keymaps.json`](../keymaps.json) by "
                 "`python3 scripts/render-parity-doc.py`. Do not edit by hand.")
    lines.append("")
    lines.append(f"**{spec['description']}**")
    lines.append("")
    lines.append(f"- spec version: `{spec['version']}` (updated {spec['updated']})")
    lines.append(f"- leader: `{spec['leader']}` in all three editors")
    total = sum(len(g["maps"]) for g in spec["groups"])
    lines.append(f"- mappings: {total}")
    lines.append("")
    lines.append("Legend: `—` = the editor has no equivalent capability; "
                 "`(cond)` = the binding is registered lazily (LSP attach, buffer attach, filetype).")
    lines.append("")

    for group in spec["groups"]:
        lines.append(f"## {group['name']}")
        lines.append("")
        lines.append("| Keys | Action | Neovim | VSCode | Zed |")
        lines.append("| --- | --- | --- | --- | --- |")
        for entry in group["maps"]:
            nvim = entry.get("nvim")
            vscode = entry.get("vscode")
            zed = entry.get("zed")
            nvim_cell = "—" if not nvim else cell(nvim["key"])
            vscode_cell = "—" if not vscode else cell(vscode["key"])
            zed_cell = "—" if not zed else cell(zed["key"])
            if entry.get("conditional"):
                nvim_cell += " (cond)"
            lines.append(
                f"| `{entry['keys']}` | {entry['action']} | {nvim_cell} | "
                f"{vscode_cell} | {zed_cell} |"
            )
        lines.append("")

    lines.append("## How the ports are produced")
    lines.append("")
    lines.append("```sh")
    lines.append("python3 scripts/render-ports.py        # regenerate the VSCode/Zed configs")
    lines.append("python3 scripts/check-parity.py        # prove all three implement the spec")
    lines.append("python3 scripts/check-parity.py --json # machine readable report")
    lines.append("```")
    lines.append("")
    lines.append("`render-ports.py` reads `keymaps.json` plus the templates in `ports/` and")
    lines.append("writes:")
    lines.append("")
    lines.append("- `~/.config/Code/User/settings.json` (the `vim.normalModeKeyBindings*` blocks)")
    lines.append("- `~/.config/Code/User/keybindings.json`")
    lines.append("- `~/.config/zed/settings.json`")
    lines.append("- `~/.config/zed/keymap.json` (the `VimControl && !menu` block)")
    lines.append("")
    lines.append("Every generated file is validated before it is written, and the previous")
    lines.append("version is kept as `<file>.prev`.")
    lines.append("")

    DOC.parent.mkdir(parents=True, exist_ok=True)
    DOC.write_text("\n".join(lines), encoding="utf-8")
    print(f"wrote {DOC} ({len(lines)} lines)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
