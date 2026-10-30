# Glass UI

The look is a Catppuccin Mocha palette with real Wayland glass: kitty renders
selected cell backgrounds semi-transparent and niri blurs the wallpaper behind
the window. Neovim itself never uses `winblend`; it keeps crisp text and hands
the transparency to kitty.

## The four translucent surfaces

| Role | Catppuccin colour | Alpha | Used by |
| --- | --- | --- | --- |
| Buffer / body | `#1e1e2e` base | `0.90` (`background_opacity`) | `Normal`, `NormalNC`, padding, shell |
| Floats / sidebars | `#181825` mantle | `0.86` | `NormalFloat`, `Pmenu`, Snacks picker, Neo-tree, hover, docs |
| Bars / chrome | `#11111b` crust | `0.80` | lualine, dropbar winbar, tmux status, kitty tabs |
| Selection / highlight | `#313244` surface0 | `0.72` | `PmenuSel`, active tab, bufferline selection |

Border palette: `#6c7086` (overlay0) for borders, `#b4befe` (lavender) for
titles/active accents, `#45475a` for separators.

## Where the values live (keep them in sync)

- `~/.config/kitty/kitty.conf` — `background_opacity` and
  `transparent_background_colors #181825@0.86 #11111b@0.80 #313244@0.72`.
  This is the **single place** that decides the alpha.
- `~/.config/nvim/lua/plugins/colorscheme.lua` — the mantle/crust/surface0
  hex values assigned to `NormalFloat`, `Pmenu`, `WinBar`, sidebars, etc.
- `~/.config/nvim/lua/plugins/ui-glass.lua` — lualine/bufferline use the same
  palette (read from the active theme, with Catppuccin fallbacks).
- `~/.tmux.conf` — status bar, pane chrome, popup/menu styles.
- `~/.config/kitty/current-theme.conf` — kitty tab bar colours.

If you change one of `#1e1e2e`, `#181825`, `#11111b`, or `#313244`, update the
others. Kitty only frosts cells whose background matches a listed colour exactly.

## Borders and menus

- `vim.o.winborder = "rounded"` — default for floating windows.
- `vim.o.pumborder = "rounded"` — native completion/mouse menus on Neovim 0.12.
- noice's hover view hard-codes `border.style = "none"`; `ui-glass.lua` overrides
  it with `rounded` + padding. Signature help uses the same view.
- blink.cmp gets explicit rounded borders for its menu, documentation and
  signature windows. `ui-glass.lua` also defines `BlinkCmpMenuBorder` /
  `BlinkCmpDocBorder` so the border is not lost when the theme does not ship
  them.
- Which-key, DAP UI and aerial floats get rounded borders / no blend.
- `winblend = 0` and `pumblend = 0`: no text ghosting. The glass effect comes
  from kitty alpha, not from blending floating windows with the code below.

## Tuning

- Live opacity: kitty defaults are `ctrl+shift+a` then `m` (more opaque),
  `l` (less opaque), `1` (fully opaque), `d` (reset to config).
- For stronger glass, lower `background_opacity` and the alpha values in
  `transparent_background_colors`. For long sessions, raise them instead.
- If the GPU starts dropping frames, raise `background_opacity` to `0.92` and/or
  lower `background_blur`; niri's `xray` blur is the cheap path.
- niri's own blur settings live in `~/.config/niri/config.kdl` (`blur {}` and
  the kitty `window-rule`). Kitty corners are rounded/clipped by niri.

## Theme switching

`:Theme <name>` still switches syntax colours. The terminal/tmux chrome is
deliberately Catppuccin; other themes keep their own float colours (opaque)
until their float/sidebar hex values are added to kitty's
`transparent_background_colors`. This is a graceful fallback, not a broken state.

## Known limits

- **tmux 3.8 has no rounded pane borders.** `pane-border-lines` only accepts
  `single`, `double`, `heavy`, `simple`, `number`, `spaces`, `none`. The pane
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
- `kitty +runpy` config check, or restart kitty and inspect:
  `background_opacity = 0.9`, `background_blur = 24`, `cursor_blink_interval = 0`.
- tmux: status bar has the prefix dot, centred windows, `COPY` indicator;
  `prefix+?` opens the themed fzf popup.
- Neovim: `K` hover and `gK`/`<c-k>` signature show rounded borders; blink
  menu/docs have rounded borders; which-key and DAP floats are bordered.
- Contrast over a worst-case white wallpaper: body/floats ≥ 7:1, bar secondary
  ≥ 4.5:1 (current: 8.45 / 7.99 / 6.99 / 4.54).
