# Glass UI

The look is a **theme-neutral glass layer**: kitty renders selected cell
backgrounds semi-transparent and niri blurs the wallpaper behind the window.
The glass surfaces are fixed; only text, borders and accents change when you
switch colorschemes.

That means `:Theme catppuccin-mocha`, `:Theme kanagawa-wave`,
`:Theme tokyonight-night` and `:Theme catppuccin-latte` all keep exactly the
same floats, menus, winbar, statusline and sidebar structure. Only the palette
inside them changes.

## The glass surfaces

| Role | Dark themes | Light themes | Alpha | Used by |
| --- | --- | --- | --- | --- |
| Buffer / body | terminal background | terminal background | `0.90` (`background_opacity`) | `Normal`, `NormalNC`, padding, shell |
| Floats / sidebars | `#15151f` | `#f2f2f7` | `0.86` / `0.92` | `NormalFloat`, `Pmenu`, Snacks picker, Neo-tree, hover, docs |
| Bars / chrome | `#0f0f17` | `#e8e8ef` | `0.80` / `0.88` | lualine, dropbar winbar, tmux status, kitty tabs |
| Selection / highlight | `#2a2a3a` | `#d8d8e2` | `0.72` / `0.82` | `PmenuSel`, active tab, bufferline selection |

Text, border and accent colours are read from the active theme:

- text → `Normal`
- border → `Comment`
- accent → `Title`
- mode/diagnostic colours → `String`, `DiagnosticWarn`, `DiagnosticError`,
  `Statement`

So a warm Kanagawa theme gets warm text/accents on the same cool dark glass; a
Catppuccin Latte session gets dark text on light glass.

## Where the values live (keep them in sync)

- `~/.config/kitty/kitty.conf` — `background_opacity` and
  `transparent_background_colors` (the six hex/alpha pairs).
  This is the **single place** that decides the alpha.
- `~/.config/nvim/lua/config/theme.lua` — `glass_dark` / `glass_light` and
  `M.chrome()`; `apply_glass()` runs on every `ColorScheme`.
- `~/.config/nvim/lua/plugins/ui-glass.lua` — lualine's theme is a function and
  bufferline's highlights are a function; both are re-evaluated on
  `ColorScheme`, using the fixed glass backgrounds.
- `~/.tmux.conf` — status bar, pane chrome, popup/menu surfaces use the same
  neutral dark glass (`#15151f` / `#0f0f17` / `#2a2a3a`).
- `~/.config/kitty/current-theme.conf` — kitty tab surfaces use the same neutral
  dark glass.

If you change a glass hex in `kitty.conf`, update the corresponding constant in
`theme.lua` (and the tmux/kitty tab surfaces). Kitty only frosts cells whose
background matches a listed colour exactly.

## Borders and menus

- `vim.o.winborder = "rounded"` — default for floating windows.
- `vim.o.pumborder = "rounded"` — native completion/mouse menus on Neovim 0.12.
- noice's hover view hard-codes `border.style = "none"`; `ui-glass.lua` overrides
  it with `rounded` + padding. Signature help uses the same view.
- blink.cmp gets explicit rounded borders for its menu, documentation and
  signature windows. `theme.lua` defines `BlinkCmpMenuBorder` /
  `BlinkCmpDocBorder` as links to the glass border.
- Which-key, DAP UI, aerial, mini.files and the Snacks picker use the same
  frosted `NormalFloat` / `FloatBorder` groups.
- `winblend = 0` and `pumblend = 0`: no text ghosting. The glass effect comes
  from kitty alpha, not from blending floating windows with the code below.

## Tuning

- Live opacity: kitty defaults are `ctrl+shift+a` then `m` (more opaque),
  `l` (less opaque), `1` (fully opaque), `d` (reset to config).
- To change the glass tint, edit the six values in `kitty.conf` **and** the two
  `glass_*` tables in `theme.lua`; keep the alpha suffix on the kitty side.
- If the GPU starts dropping frames, raise `background_opacity` to `0.92` and/or
  lower `background_blur`; niri's `xray` blur is the cheap path.
- niri's own blur settings live in `~/.config/niri/config.kdl` (`blur {}` and
  the kitty `window-rule`). Kitty corners are rounded/clipped by niri.

## Theme switching

There are no per-theme overrides to maintain. `lua/config/theme.lua` applies the
glass groups on every `ColorScheme`; lualine and bufferline recompute their
highlights from `M.chrome()`. Adding another colorscheme only means adding its
plugin and name to `M.themes` for the `:Theme` completion list.

`vim.o.background` decides dark vs light glass, so light palettes automatically
use the light surfaces and darker text.

## Known limits

- **tmux 3.8 has no rounded pane borders.** `pane-border-lines` only accepts
  `single`, `double`, `heavy`, `simple`, `number`, `spaces`, `none`. Pane
  borders are single-line with tinted colours; popups and menus *are* rounded.
- **CSD / focus ring:** if a transparent kitty ever shows the focus-ring
  rectangle through the window, niri's `prefer-no-csd` (global, requires app
  restarts) is the fallback. The kitty window rule already sets
  `draw-border-with-background false`.
- **Other terminals:** the `transparent_background_colors` trick is kitty-only.
  In another terminal the same config is simply opaque and readable.
- **True per-syntax dimming of inactive splits** would need a plugin; this setup
  only dims `NormalNC` foreground text.

## Verification checklist

- `niri validate -c ~/.config/niri/config.kdl`
- kitty config check: `background_opacity = 0.9`,
  `background_blur = 24`, `cursor_blink_interval = 0`, six alpha pairs.
- Switch themes and assert the surface hexes do not change:
  ```vim
  :Theme catppuccin-mocha
  :lua print(vim.inspect(vim.api.nvim_get_hl(0, { name = "NormalFloat" })))
  :Theme kanagawa-wave
  :lua print(vim.inspect(vim.api.nvim_get_hl(0, { name = "NormalFloat" })))
  ```
  Both should report `bg = 0x15151f`; text/border/accent should differ.
- `:Theme catppuccin-latte` should report light surfaces (`#f2f2f7` float,
  `#e8e8ef` bar) and dark text.
- Neovim: `K` hover and `gK`/`<c-k>` signature show rounded borders; blink
  menu/docs, which-key and DAP floats are bordered.
- Contrast over worst-case backdrops: dark float **8.28:1**, dark bar
  **7.23:1** with Catppuccin text over white; light float **6.01:1**, light bar
  **5.00:1** with Catppuccin Latte text over black. Body contrast depends on the
  terminal theme and `background_opacity`.
