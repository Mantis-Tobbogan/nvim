# Neovim config

A [LazyVim](https://www.lazyvim.org/) based setup tuned for **code editing** (Go,
Python, Nushell), **text editing** (Markdown/JSON/YAML) and everyday comfort.
Designed to be cloned to several machines and behave identically thanks to the
committed `lazy-lock.json`.

## Requirements

Install these on every machine before first launch:

| Tool | Why | Install |
| --- | --- | --- |
| Neovim (>= 0.10) | the editor | distro package / [releases](https://github.com/neovim/neovim/releases) |
| git | plugins + this repo | distro package |
| ripgrep (`rg`) | grep/telescope | distro package |
| fd | file finding | distro package |
| fzf | fuzzy finder | distro package |
| a C compiler + `make` | treesitter parsers | distro package (`gcc`/`clang`) |
| [mise](https://mise.jdx.dev/) | CLI tools (prettier, …) | `curl https://mise.run \| sh` |
| a [Nerd Font](https://www.nerdfonts.com/) | icons | e.g. `CaskaydiaCove Nerd Font` |

Optional but recommended: `node`/`npm` (for some LSP servers installed by Mason),
`lazygit`, `tree-sitter`.

### mise

The setup uses **mise** for external formatters so the same binary is available
in the shell, in Neovim and in CI — not locked inside Neovim. Currently:

```sh
mise use -g prettier
```

`lua/config/options.lua` prepends the mise shims directory to Neovim's `PATH`,
so tools are found even when Neovim is launched from a GUI.

**Mason** is kept for Neovim-internal tooling (LSP servers and DAP adapters).
Prettier is deliberately *removed* from Mason's install list in
`lua/plugins/formatting.lua` so there is exactly one source of truth.

## Install on a new machine

```sh
git clone https://github.com/Mantis-Tobbogan/nvim.git ~/.config/nvim
mise use -g prettier
nvim
```

On first launch lazy.nvim installs all plugins from `lazy-lock.json`. Wait for
`:Lazy` to finish, then `:Mason` finishes installing LSP servers/DAP adapters.

## Updating

```sh
nvim --headless "+Lazy! sync" +qa   # or `:Lazy update` interactively
git diff lazy-lock.json && git commit -am "chore: update plugins"
```

Always commit `lazy-lock.json` after updating so the other machines can `git pull`
and reproduce exactly the same versions.

## Layout

```
init.lua                     # bootstraps lua/config/lazy.lua
lazyvim.json                 # enabled LazyVim extras (the "switchboard")
lazy-lock.json               # pinned plugin versions (commit this!)
lua/config/
  lazy.lua                   # lazy.nvim bootstrap
  options.lua                # editor options + mise PATH
  theme.lua                  # theme, transparency, :Theme command
  keymaps.lua                # personal keymaps
  autocmds.lua               # personal autocommands
  dap/                       # debugger launch configs (python)
lua/plugins/
  colorscheme.lua            # theme plugins
  formatting.lua             # prettier via mise (not Mason)
  nvim-dap.lua               # debugger wiring (dap.core + F-keys + python)
  dropbar.lua                # winbar (breadcrumbs)
  ...                        # other plugin tweaks
```

## Custom mappings worth knowing

See [`KEYMAPS.md`](./KEYMAPS.md) for the full, up-to-date cheatsheet (navigation,
git, debug, tests, refactoring, multi-cursor, and the meta-skills).

| Mapping | Action |
| --- | --- |
| `<C-c>` | yank (line in normal mode, selection in visual) |
| `<C-S-v>` | paste from system clipboard |
| `<leader>;` | pick symbol from dropbar winbar |
| `[;` / `];` | go to start of context / next context |
| `<leader>dt` / `<leader>dc` | debug: toggle breakpoint / continue |
| `<leader>du` | debug: toggle DAP UI |
| `:Theme [name]` | list/switch theme at runtime |

## Changing things

- **Add a language / feature:** edit `lazyvim.json` `extras` (or run `:LazyExtras`).
- **Add a theme:** add the plugin in `lua/plugins/colorscheme.lua` and list the
  variant in `lua/config/theme.lua`.
- **Add a formatter:** `mise use -g <tool>`, then add it to conform under the
  right filetype (many are covered by the `formatting.prettier` extra).
