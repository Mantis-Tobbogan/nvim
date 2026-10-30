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
      custom_highlights = function(colors)
        return {
          -- Catppuccin's default comment color (overlay0) is quite dim; nudge
          -- it up one step for noticeably better readability.
          Comment = { fg = colors.overlay1 },
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
