# Keymaps & commands

**The same keys mean the same thing in Neovim, VSCode and Zed.** The leader is
`<space>` everywhere. The table below is the curated core; the full matrix
(including the per-editor implementation of every key) is in
[`docs/EDITOR-PARITY.md`](./docs/EDITOR-PARITY.md).

Everything listed here works out of the box in all three editors. `which-key`
in Neovim and Zed also shows these: press `<leader>` and wait, or `<leader>?`.

## Files & search

| Key | Action |
| --- | --- |
| `<leader><space>` | Find files (project root) |
| `<leader>/` | Live grep (project root) |
| `<leader>fg` | Find files tracked by git |
| `<leader>fr` | Recently opened files |
| `<leader>fb` | Buffer picker |
| `<leader>fB` | All buffers (including unlisted) |
| `<leader>fm` | Browse files (directory of current file) |
| `<leader>fM` | Browse files (working directory) |
| `<leader>e` | File explorer (project root) |
| `<leader>E` | Toggle explorer / sidebar panel |
| `<leader>ft` | Toggle integrated terminal (project root) |
| `<leader>fT` | Toggle integrated terminal (working directory) |

## Buffers & tabs

| Key | Action |
| --- | --- |
| `<leader>,` | Switch buffer |
| `<leader>be` | Buffer explorer |
| `<leader>bp` | Pin buffer / tab |
| `<leader>bd` | Delete buffer |
| `<leader>bl` / `<leader>br` | Close buffers to the left / right |
| `]b` / `[b` | Next / previous buffer |

## Windows & panes

| Key | Action |
| --- | --- |
| `<leader>\|` | Split to the right (vertical split) |
| `<leader>-` | Split below (horizontal split) |
| `<leader>wd` | Close window / editor group |
| `<leader>wm` | Toggle zoom (maximize pane) |
| `<C-h/j/k/l>` | Focus pane left / below / above / right |

## LSP navigation

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `gr` | Find references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `gK` | Signature help |
| `<leader>ca` | Code action (quick fix) |
| `<leader>cr` | Rename symbol |
| `[[` / `]]` | Previous / next reference |

## Diagnostics & todos

| Key | Action |
| --- | --- |
| `]d` / `[d` | Next / previous diagnostic |
| `<leader>xx` | Workspace diagnostics (Trouble / Problems) |
| `<leader>xX` | Buffer diagnostics |
| `<leader>sd` | Diagnostics picker |
| `]t` / `[t` | Next / previous TODO comment |

## Git

| Key | Action |
| --- | --- |
| `<leader>gg` / `<leader>gG` | Lazygit (project root / working directory) |
| `<leader>gs` | Git status |
| `<leader>gc` | Git commits |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` / `<leader>ghB` | Blame current line / whole buffer |
| `]h` / `[h` | Next / previous git hunk |

> VSCode has no "next/previous hunk" command, so `]h` / `[h` are Neovim + Zed only.

## Editing

| Key | Action |
| --- | --- |
| `gcc` | Toggle comment on line |
| `<leader>cf` | Format buffer |
| `gsa` / `gsd` / `gsr` | Add / delete / replace surrounding pair |
| `<C-a>` / `<C-x>` | Increment / decrement number under cursor |
| `<C-n>` | Add cursor below (multi-cursor) |
| `<C-S-n>` | Add cursor above (multi-cursor) |
| `s` / `S` | Jump to visible text / to a treesitter symbol (flash) |
| `<leader>p` | Paste from yank history |
| `<C-c>` | Copy to the system clipboard |
| `<C-S-v>` | Paste from the system clipboard |

> Surround, increment/decrement, flash-jump and the yank history are Neovim only.

## Symbols, focus & workspace

| Key | Action |
| --- | --- |
| `<leader>cs` | Symbol outline (current file) |
| `<leader>sS` | Workspace symbols |
| `<leader>sk` | Show keymaps |
| `<leader>sr` | Search and replace |
| `<leader>sj` | Jump back (jumplist) |
| `<leader>sp` | Command palette (VSCode + Zed) |
| `<leader>uz` | Zen mode (distraction free) |
| `<leader>uu` | Undo tree (Neovim only) |
| `<leader>cp` | Markdown preview in browser |
| `<leader>qq` | Quit window |
| `<leader>qa` | Quit all editors (VSCode + Zed) |

## Debug

| Key | Action |
| --- | --- |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Run / continue |
| `<leader>di` / `<leader>do` / `<leader>dO` | Step into / out / over |
| `<leader>dt` | Terminate session |
| `<F5>` / `<F9>` / `<F10>` / `<F11>` | Run / breakpoint / step over / step into |

## Tests

| Key | Action |
| --- | --- |
| `<leader>tt` | Run test file |
| `<leader>tr` | Run nearest test |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Show output |
| `<leader>tw` | Watch test file |

> VSCode maps `<leader>tt` / `<leader>tr` to the Testing panel; Zed has no test runner UI.

## Neovim-only extras

These live in the Neovim config and have no counterpart in the other two
editors, but they are worth knowing:

| Key | Action |
| --- | --- |
| `<C-c>` | Yank to the system clipboard (Neovim keeps separate registers) |
| `<C-S-v>` | Paste from the system clipboard |
| `<leader>;` | Pick a symbol from the winbar (dropbar) |
| `[;` / `];` | Go to the start of the context / next context |
| `<leader>du` | Toggle the DAP UI |
| `<leader>de` | Evaluate the expression under the cursor |
| `<leader>um` | Toggle in-buffer Markdown rendering |
| `<leader>uu` | Undo tree |
| `<leader>uz` | Zen mode |
| `:Theme [name]` | List / switch the colorscheme at runtime |

## The meta-skills (worth internalising)

| Command | What it does |
| --- | --- |
| `:LazyExtras` | Browse/enable features the LazyVim way — **the answer to "how do I add X?"** |
| `:Lazy` | Plugin manager: update, sync, profile, inspect |
| `:Mason` | LSP servers / DAP adapters / tools, and their install logs |
| `:ConformInfo` | Which formatters apply to the current buffer and where they come from |
| `:LspInfo` | Which language servers are attached to this buffer |
| `:checkhealth` | Diagnose anything that feels broken |
| `:Tutor` | Vim fundamentals, guided |

## Vim fundamentals worth internalising

- **Text objects:** `ci(`, `da{`, `yi"`, `vaf` (function), `via` (argument).
- **Registers:** `"0` last yank, `"+` system clipboard, `"_` black hole.
- **Macros:** `q<reg>` record, `@<reg>` play, `@@` repeat.
- **Command history:** `q:` (command-line), `g;` / `g,` (edit history).
- **Jumps:** `<C-o>` / `<C-i>` back / forward, `` `` `` last position.
- **`.`** repeats the last change — the single most underrated key.
