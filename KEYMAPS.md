# Keymaps & commands

Everything here works out of the box in this config. `which-key` shows these
too: press `<leader>` and wait, or `<leader>?`.

## The meta-skills (learn these first)

| Command | What it does |
| --- | --- |
| `:LazyExtras` | Browse/enable features the LazyVim way — **the answer to "how do I add X?"** |
| `:Lazy` | Plugin manager: update, sync, profile, inspect |
| `:Mason` | LSP servers / DAP adapters / tools, and their install logs |
| `:ConformInfo` | Which formatters apply to the current buffer and where they come from |
| `:LspInfo` | Which language servers are attached to this buffer |
| `:checkhealth` | Diagnose anything that feels broken |
| `:Tutor` | Vim fundamentals, guided |

## Files, buffers, search

| Key | Action |
| --- | --- |
| `<leader><space>` | Find files (root) |
| `<leader>/` | Live grep (root) |
| `<leader>,` | Buffers |
| `<leader>e` | File explorer (neo-tree) |
| `<leader>fm` | mini.files — edit the filesystem **as a buffer** (dir of current file) |
| `<leader>fM` | mini.files (cwd) |
| `<C-h/j/k/l>` | Move between windows |
| `s` / `S` | Leap forward / backward to any location (2 keystrokes) |
| `gs` | Leap across windows |

## Navigation between things

| Key | Action |
| --- | --- |
| `gd` / `gr` / `gI` | Definition / references / implementation |
| `K` | Hover docs (rounded popup) |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol (live preview via inc-rename) |
| `]d` / `[d` | Next / previous diagnostic |
| `]c` / `[c` | Next / previous git hunk |
| `]t` / `[t` | Next / previous TODO comment |
| `<leader>cs` | Aerial symbol browser |
| `<leader>xx` | Trouble: workspace diagnostics |
| `<leader>xX` | Trouble: buffer diagnostics |
| `<leader>cS` | Trouble: LSP references/definitions |
| `<leader>xt` | Trouble: todos |

## Editing

| Key | Action |
| --- | --- |
| `<leader>p` | Yank history (paste from the ring) |
| `[y` / `]y` | Cycle through yank history while pasting |
| `p` / `P` / `gp` / `gP` | Paste (yanky-backed, history-aware) |
| `<C-a>` / `<C-x>` | Increment / decrement numbers, dates, booleans (dial) |
| `gsa` / `gsd` / `gsr` | Add / delete / replace surrounding (mini.surround) |
| `gcc` / `gc` | Comment line / selection |
| `<leader>rf` | Extract function (refactor) |
| `<leader>rv` | Extract variable (refactor) |
| `<leader>ri` | Inline variable (refactor) |
| `<leader>rp` | Debug print (refactor) |
| `<C-n>` | Multi-cursor: select next occurrence (visual-multi) |
| `<C-Down>` / `<C-Up>` | Multi-cursor: add cursor below / above |
| `w` / `e` / `b` | Spider motions (stop at camelCase/snake_case) |
| `gq` / `<leader>cf` | Format (LSP / conform) |

## Git

| Key | Action |
| --- | --- |
| `<leader>gg` / `<leader>gG` | Lazygit (root / cwd) |
| *(automatic)* | Inline blame on the current line (gitsigns) |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` / `<leader>ghB` | Blame line / buffer |
| `]c` / `[c` | Next / previous hunk |

## Debug (DAP)

| Key | Action |
| --- | --- |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Run / continue · `<F5>` alias |
| `<leader>di` / `<leader>do` / `<leader>dO` | Step into / out / over |
| `<leader>dt` | Terminate |
| `<leader>du` | Toggle DAP UI |
| `<leader>dr` | Toggle REPL |
| `<leader>de` | Evaluate expression under cursor |
| `<F9>` / `<F10>` / `<F11>` | Breakpoint / step over / step into |

## Tests

| Key | Action |
| --- | --- |
| `<leader>tt` | Run test file |
| `<leader>tr` | Run nearest test |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Show output |
| `<leader>tw` | Watch test file |

## Focus / writing

| Key | Action |
| --- | --- |
| `<leader>uz` | Zen Mode (distraction-free) |
| `<leader>uu` | Undo tree |
| `<leader>cp` | Markdown preview in browser |
| `<leader>um` | Toggle in-buffer Markdown rendering (off by default) |
| `]p` / `[p` | Paste indented (linewise) |

## Vim fundamentals worth internalizing

- **Text objects:** `ci(`, `da{`, `yi"`, `vaf` (function), `via` (argument).
- **Registers:** `"0` last yank, `"+` system clipboard, `"_` black hole.
- **Macros:** `q<reg>` record, `@<reg>` play, `@@` repeat.
- **Command history:** `q:` (command-line), `g;` / `g,` (edit history).
- **Jumps:** `<C-o>` / `<C-i>` back / forward, `` `` `` last position.
- **`.`** repeats the last change — the single most underrated key.
