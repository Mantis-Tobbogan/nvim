# Editor parity matrix

Generated from [`keymaps.json`](../keymaps.json) by `python3 scripts/render-parity-doc.py`. Do not edit by hand.

**Canonical keymap spec shared by Neovim (LazyVim), VSCode (VSCodeVim) and Zed (native vim). Neovim is the source of truth; VSCode and Zed are ports. A null editor means that editor has no equivalent capability.**

- spec version: `1` (updated 2026-10-20)
- leader: `space` in all three editors
- mappings: 93

Legend: `—` = the editor has no equivalent capability; `(cond)` = the binding is registered lazily (LSP attach, buffer attach, filetype).

## Files & search

| Keys | Action | Neovim | VSCode | Zed |
| --- | --- | --- | --- | --- |
| `space space` | Find files (project root) | `<leader><space>` | `space space` | `space space` |
| `space /` | Live grep (project root) | `<leader>/` | `space /` | `space /` |
| `space f g` | Find files tracked by git | `<leader>fg` | `space f g` | `space f g` |
| `space f r` | Recently opened files | `<leader>fr` | `space f r` | `space f r` |
| `space f b` | Buffer picker | `<leader>fb` | `space f b` | `space f b` |
| `space f B` | All buffers (including unlisted) | `<leader>fB` | `space f B` | `space f B` |
| `space f m` | Browse files (directory of current file) | `<leader>fm` | `space f m` | `space f m` |
| `space f M` | Browse files (working directory) | `<leader>fM` | `space f M` | `space f M` |
| `space e` | File explorer (project root) | `<leader>e` | `space e` | `space e` |
| `space E` | Toggle explorer / sidebar panel | `<leader>E` | `space E` | `space E` |

## Buffers & tabs

| Keys | Action | Neovim | VSCode | Zed |
| --- | --- | --- | --- | --- |
| `space ,` | Switch buffer | `<leader>,` | `space ,` | `space ,` |
| `space b e` | Buffer explorer | `<leader>be` | `space b e` | `space b e` |
| `space b p` | Pin buffer / tab | `<leader>bp` | `space b p` | `space b p` |
| `space b d` | Delete buffer | `<leader>bd` | `space b d` | `space b d` |
| `space b l` | Close buffers to the left | `<leader>bl` | `space b l` | `space b l` |
| `space b r` | Close buffers to the right | `<leader>br` | `space b r` | `space b r` |
| `] b` | Next buffer | `]b` | `] b` | `] b` |
| `[ b` | Previous buffer | `[b` | `[ b` | `[ b` |

## Windows & panes

| Keys | Action | Neovim | VSCode | Zed |
| --- | --- | --- | --- | --- |
| `space w v` | Split to the right (vertical split) | `<leader>|` | `space w v` | `space w v` |
| `space w s` | Split below (horizontal split) | `<leader>-` | `space w s` | `space w s` |
| `space w d` | Close window / editor group | `<leader>wd` | `space w d` | `space w d` |
| `space w m` | Toggle zoom (maximize pane) | `<leader>wm` | `space w m` | `space w m` |
| `ctrl-h` | Focus pane on the left | `<C-h>` | `ctrl+h` | `ctrl-h` |
| `ctrl-j` | Focus pane below | `<C-j>` | `ctrl+j` | `ctrl-j` |
| `ctrl-k` | Focus pane above | `<C-k>` | `ctrl+k` | `ctrl-k` |
| `ctrl-l` | Focus pane on the right | `<C-l>` | `ctrl+l` | `ctrl-l` |

## LSP navigation

| Keys | Action | Neovim | VSCode | Zed |
| --- | --- | --- | --- | --- |
| `g d` | Go to definition | `gd` (cond) | `g d` | `g d` |
| `g r` | Find references | `gr` (cond) | `g r` | `g r` |
| `g I` | Go to implementation | `gI` (cond) | `g I` | `g I` |
| `g y` | Go to type definition | `gy` (cond) | `g y` | `g y` |
| `K` | Hover documentation | `K` (cond) | `K` | `K` |
| `g K` | Signature help | `gK` (cond) | `g K` | `g K` |
| `space c a` | Code action (quick fix) | `<leader>ca` (cond) | `space c a` | `space c a` |
| `space c r` | Rename symbol | `<leader>cr` (cond) | `space c r` | `space c r` |
| `] ]` | Next reference | `]]` | `] ]` | `] ]` |
| `[ [` | Previous reference | `[[` | `[ [` | `[ [` |

## Diagnostics & todos

| Keys | Action | Neovim | VSCode | Zed |
| --- | --- | --- | --- | --- |
| `] d` | Next diagnostic | `]d` | `] d` | `] d` |
| `[ d` | Previous diagnostic | `[d` | `[ d` | `[ d` |
| `space x x` | Workspace diagnostics (Trouble / Problems) | `<leader>xx` | `space x x` | `space x x` |
| `space x X` | Buffer diagnostics | `<leader>xX` | `space x X` | `space x X` |
| `space s d` | Diagnostics picker | `<leader>sd` | `space s d` | `space s d` |
| `] t` | Next TODO comment | `]t` | `] t` | — |
| `[ t` | Previous TODO comment | `[t` | `[ t` | — |

## Git

| Keys | Action | Neovim | VSCode | Zed |
| --- | --- | --- | --- | --- |
| `space g g` | Git UI (project root) | `<leader>gg` | `space g g` | `space g g` |
| `space g G` | Git UI (working directory) | `<leader>gG` | `space g G` | `space g G` |
| `space g s` | Git status | `<leader>gs` | `space g s` | `space g s` |
| `space g c` | Git commits | `<leader>gc` | `space g c` | `space g c` |
| `space g h s` | Stage hunk | `<leader>ghs` (cond) | `space g h s` | `space g h s` |
| `space g h r` | Reset hunk | `<leader>ghr` (cond) | `space g h r` | `space g h r` |
| `space g h p` | Preview hunk inline | `<leader>ghp` (cond) | `space g h p` | `space g h p` |
| `space g h b` | Blame current line | `<leader>ghb` (cond) | `space g h b` | `space g h b` |
| `space g h B` | Blame whole buffer | `<leader>ghB` (cond) | `space g h B` | `space g h B` |
| `] h` | Next git hunk | `]h` (cond) | — | `] h` |
| `[ h` | Previous git hunk | `[h` (cond) | — | `[ h` |

## Editing

| Keys | Action | Neovim | VSCode | Zed |
| --- | --- | --- | --- | --- |
| `g c c` | Toggle comment on line | `gcc` | `g c c` | `g c c` |
| `space c f` | Format buffer | `<leader>cf` | `space c f` | `space c f` |
| `g s a` | Add surrounding pair | `gsa` | — | — |
| `g s d` | Delete surrounding pair | `gsd` | — | — |
| `g s r` | Replace surrounding pair | `gsr` | — | — |
| `ctrl-a` | Increment number under cursor | `<C-a>` | — | — |
| `ctrl-x` | Decrement number under cursor | `<C-x>` | — | — |
| `ctrl-n` | Add cursor below (multi-cursor) | `<C-n>` | `ctrl+n` | `ctrl-n` |
| `ctrl-shift-n` | Add cursor above (multi-cursor) | `<C-Down>` | `ctrl+shift+n` | `ctrl-shift-n` |
| `s` | Jump to visible text (flash) | `s` | — | — |
| `S` | Jump to treesitter symbol (flash) | `S` | — | — |
| `space p` | Paste from yank history | `<leader>p` | — | — |
| `ctrl-c` | Copy to system clipboard | `<C-c>` | `ctrl+c` | `ctrl-c` |
| `ctrl-shift-v` | Paste from system clipboard | `<C-S-v>` | `ctrl+shift+v` | `ctrl-shift-v` |

## Symbols, focus & workspace

| Keys | Action | Neovim | VSCode | Zed |
| --- | --- | --- | --- | --- |
| `space c s` | Symbol outline (current file) | `<leader>cs` | `space c s` | `space c s` |
| `space s S` | Workspace symbols | `<leader>sS` | `space s S` | `space s S` |
| `space s k` | Show keymaps | `<leader>sk` | `space s k` | `space s k` |
| `space u z` | Zen mode (distraction free) | `<leader>uz` | `space u z` | `space u z` |
| `space u u` | Undo tree | `<leader>uu` | — | — |
| `space c p` | Markdown preview in browser | `<leader>cp` (cond) | `space c p` | — |
| `space q q` | Quit window (nvim quits everything) | `<leader>qq` | `space q q` | `space q q` |
| `space q a` | Quit all editors | — | `space q a` | `space q a` |
| `space s p` | Command palette | — | `space s p` | `space s p` |
| `space s j` | Jump back (jumplist) | `<leader>sj` | `space s j` | `space s j` |
| `space s r` | Search and replace | `<leader>sr` | `space s r` | `space s r` |

## Debug

| Keys | Action | Neovim | VSCode | Zed |
| --- | --- | --- | --- | --- |
| `space d b` | Toggle breakpoint | `<leader>db` | `space d b` | `space d b` |
| `space d c` | Run / continue | `<leader>dc` | `space d c` | `space d c` |
| `space d i` | Step into | `<leader>di` | `space d i` | `space d i` |
| `space d o` | Step out | `<leader>do` | `space d o` | `space d o` |
| `space d O` | Step over | `<leader>dO` | `space d O` | `space d O` |
| `space d t` | Terminate session | `<leader>dt` | `space d t` | `space d t` |
| `F5` | Run / continue | `<F5>` | `F5` | — |
| `F9` | Toggle breakpoint | `<F9>` | `F9` | — |
| `F10` | Step over | `<F10>` | `F10` | — |
| `F11` | Step into | `<F11>` | `F11` | — |

## Terminal & tests

| Keys | Action | Neovim | VSCode | Zed |
| --- | --- | --- | --- | --- |
| `space f t` | Toggle integrated terminal (project root) | `<leader>ft` | `space f t` | `space f t` |
| `space f T` | Toggle integrated terminal (working directory) | `<leader>fT` | `space f T` | `space f T` |
| `space t t` | Run test file | `<leader>tt` | `space t t` | — |
| `space t r` | Run nearest test | `<leader>tr` | `space t r` | — |

## How the ports are produced

```sh
python3 scripts/render-ports.py        # regenerate the VSCode/Zed configs
python3 scripts/check-parity.py        # prove all three implement the spec
python3 scripts/check-parity.py --json # machine readable report
```

`render-ports.py` reads `keymaps.json` plus the templates in `ports/` and
writes:

- `~/.config/Code/User/settings.json` (the `vim.normalModeKeyBindings*` blocks)
- `~/.config/Code/User/keybindings.json`
- `~/.config/zed/settings.json`
- `~/.config/zed/keymap.json` (the `VimControl && !menu` block)

Every generated file is validated before it is written, and the previous
version is kept as `<file>.prev`.
