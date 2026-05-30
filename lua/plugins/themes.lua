-- ============================================================================
-- THEMES CONFIGURATION
-- ============================================================================
-- Simple, portable theme setup. Edit the config below to change your theme.
--
-- CONFIGURATION:
local config = {
  default_theme = "kanagawa-wave", -- Change this to switch default theme
  transparent = true, -- Set to false to disable transparency
}
--
-- AVAILABLE THEMES:
--   kanagawa, kanagawa-wave, kanagawa-dragon, kanagawa-lotus
--   tokyonight, tokyonight-night, tokyonight-storm, tokyonight-day, tokyonight-moon
--   catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
--   gruvbox
--   rose-pine, rose-pine-moon, rose-pine-dawn
--   nord
--   bamboo, bamboo-vulgaris, bamboo-multiplex
--   monokai-pro, monokai-pro-classic, monokai-pro-machine, monokai-pro-octagon, monokai-pro-ristretto, monokai-pro-spectrum
-- ============================================================================

-- Store config globally for other modules to access
_G.theme_config = config

return {
  -- Tokyo Night
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
  },

  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
  },

  -- Kanagawa (default)
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
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
        overrides = function(colors)
          return {}
        end,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus",
        },
      })
    end,
  },

  -- Gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000,
  },

  -- Rose Pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000,
  },

  -- Nord
  {
    "shaunsingh/nord.nvim",
    lazy = true,
    priority = 1000,
  },

  -- Bamboo
  {
    "ribru17/bamboo.nvim",
    lazy = true,
    priority = 1000,
  },

  -- Monokai Pro
  {
    "loctvl842/monokai-pro.nvim",
    lazy = true,
    priority = 1000,
  },

  -- Apply the configured theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = config.default_theme,
    },
  },
}
