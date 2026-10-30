-- Colorscheme plugins. The default is chosen in lua/config/theme.lua.
--
-- lazy.nvim lazy-loads these on `:colorscheme <name>` (see its ColorSchemePre
-- handler), so keeping them `lazy = true` costs nothing until used.
local theme = require("config.theme")

return {
  { "folke/tokyonight.nvim", lazy = true, priority = 1000 },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = {
      flavour = "mocha",
      -- Catppuccin normally supports `float.solid`, but we want the border
      -- visible and the surface tinted (not a solid titlebar block).
      float = { transparent = false, solid = false },
      -- Glass surfaces. The mantle/crust/surface0 hexes must stay in sync with
      -- kitty.conf's transparent_background_colors (see docs/GLASS-UI.md).
      custom_highlights = function(colors)
        return {
          -- Catppuccin's default comment color (overlay0) is quite dim; nudge
          -- it up one step for noticeably better readability.
          Comment = { fg = colors.overlay1 },

          NormalFloat = { fg = colors.text, bg = colors.mantle },
          FloatBorder = { fg = colors.overlay0, bg = colors.mantle },
          FloatTitle = { fg = colors.lavender, bg = colors.mantle, style = { "bold" } },

          Pmenu = { fg = colors.overlay2, bg = colors.mantle },
          PmenuBorder = { fg = colors.overlay0, bg = colors.mantle },
          PmenuSel = { fg = colors.text, bg = colors.surface0, style = { "bold" } },
          PmenuKind = { fg = colors.blue, bg = colors.mantle },
          PmenuKindSel = { fg = colors.blue, bg = colors.surface0, style = { "bold" } },
          PmenuExtra = { fg = colors.overlay0, bg = colors.mantle },
          PmenuExtraSel = { fg = colors.overlay0, bg = colors.surface0, style = { "bold" } },
          PmenuSbar = { bg = colors.surface0 },
          PmenuThumb = { bg = colors.overlay0 },

          -- blink.cmp sets these border groups explicitly in its winhighlight;
          -- without definitions the menu would lose its rounded border.
          BlinkCmpMenu = { link = "Pmenu" },
          BlinkCmpMenuBorder = { fg = colors.overlay0, bg = colors.mantle },
          BlinkCmpDoc = { link = "NormalFloat" },
          BlinkCmpDocBorder = { fg = colors.overlay0, bg = colors.mantle },
          BlinkCmpSignatureHelp = { link = "NormalFloat" },
          BlinkCmpSignatureHelpBorder = { fg = colors.overlay0, bg = colors.mantle },

          -- Chrome: the winbar is a thin crust strip, sidebars keep mantle.
          WinBar = { fg = colors.subtext0, bg = colors.crust },
          WinBarNC = { fg = colors.overlay0, bg = colors.crust },
          WinSeparator = { fg = colors.surface1, bg = "NONE" },
          NeoTreeWinSeparator = { fg = colors.surface1, bg = colors.mantle },

          -- Long-hours comfort: a quieter current-line band and soft inactive
          -- window text. The background stays transparent via theme.lua.
          CursorLine = { bg = "#252536" },
          NormalNC = { fg = colors.subtext0 },

          -- Noice popups consume NormalFloat/FloatBorder by default; make the
          -- relationships explicit so hover and cmdline share the glass tint.
          NoicePopup = { link = "NormalFloat" },
          NoicePopupBorder = { link = "FloatBorder" },
          NoiceCmdlinePopup = { link = "NormalFloat" },
          NoiceCmdlinePopupBorder = { fg = colors.lavender, bg = colors.mantle },
          NoiceCmdlinePopupTitle = { fg = colors.lavender, bg = colors.mantle, style = { "bold" } },
          NoiceConfirm = { link = "NormalFloat" },
          NoiceConfirmBorder = { fg = colors.blue, bg = colors.mantle },
        }
      end,
    },
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function()
        return {}
      end,
      theme = "wave",
      background = { dark = "wave", light = "lotus" },
    },
  },

  { "ellisonleao/gruvbox.nvim", lazy = true, priority = 1000 },

  { "rose-pine/neovim", name = "rose-pine", lazy = true, priority = 1000 },

  { "shaunsingh/nord.nvim", lazy = true, priority = 1000 },

  { "ribru17/bamboo.nvim", lazy = true, priority = 1000 },

  { "loctvl842/monokai-pro.nvim", lazy = true, priority = 1000 },

  -- Apply the configured default theme.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = theme.config.default_theme,
    },
  },
}
