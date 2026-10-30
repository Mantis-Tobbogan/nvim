-- Glass UI: frosted surfaces for floats/menus, rounded borders everywhere,
-- and a theme-neutral chrome.
--
-- The *surfaces* are deliberately fixed across colorschemes; only text,
-- borders and accents are read from the active theme. That way switching from
-- Catppuccin to Kanagawa (or anything else) changes colours, never the glass
-- structure. Keep the surface hexes in sync with kitty.conf:
--   #15151f / #f2f2f7  @ 0.86 (floats, menus, sidebars)
--   #0f0f17 / #e8e8ef  @ 0.80 (lualine, winbar, tmux status, kitty tabs)
--   #2a2a3a / #d8d8e2  @ 0.72 (selected completion/tab)

local theme = require("config.theme")

local function lualine_theme()
  local c = theme.chrome()
  local section = {
    a = { fg = c.bar, bg = c.accent, gui = "bold" },
    b = { fg = c.text, bg = c.bar },
    c = { fg = c.border, bg = c.bar },
  }
  local inactive = { fg = c.border, bg = c.bar }

  return {
    normal = section,
    insert = { a = { fg = c.bar, bg = c.green, gui = "bold" }, b = section.b, c = section.c },
    visual = { a = { fg = c.bar, bg = c.mauve, gui = "bold" }, b = section.b, c = section.c },
    replace = { a = { fg = c.bar, bg = c.red, gui = "bold" }, b = section.b, c = section.c },
    command = { a = { fg = c.bar, bg = c.yellow, gui = "bold" }, b = section.b, c = section.c },
    terminal = { a = { fg = c.bar, bg = c.green, gui = "bold" }, b = section.b, c = section.c },
    inactive = { a = inactive, b = inactive, c = inactive },
  }
end

local function bufferline_highlights()
  local c = theme.chrome()
  return {
    fill = { bg = c.bar },
    background = { fg = c.border, bg = c.bar },
    buffer = { fg = c.border, bg = c.bar },
    buffer_visible = { fg = c.text, bg = c.bar },
    buffer_selected = { fg = c.text, bg = c.selection, bold = true, italic = false },
    numbers = { fg = c.border, bg = c.bar },
    numbers_visible = { fg = c.border, bg = c.bar },
    numbers_selected = { fg = c.text, bg = c.selection, bold = true },
    close_button = { fg = c.border, bg = c.bar },
    close_button_visible = { fg = c.border, bg = c.bar },
    close_button_selected = { fg = c.red, bg = c.selection },
    modified = { fg = c.yellow, bg = c.bar },
    modified_visible = { fg = c.yellow, bg = c.bar },
    modified_selected = { fg = c.yellow, bg = c.selection },
    duplicate = { fg = c.yellow, bg = c.bar },
    duplicate_visible = { fg = c.yellow, bg = c.bar },
    duplicate_selected = { fg = c.yellow, bg = c.selection, bold = true },
    separator = { fg = c.border, bg = c.bar },
    separator_visible = { fg = c.border, bg = c.bar },
    separator_selected = { fg = c.selection, bg = c.bar },
    offset_separator = { fg = c.border, bg = c.bar },
    indicator_selected = { fg = c.accent, bg = c.selection },
    indicator_visible = { fg = c.border, bg = c.bar },
    pick = { fg = c.bar, bg = c.accent, bold = true },
    pick_visible = { fg = c.bar, bg = c.yellow, bold = true },
    pick_selected = { fg = c.bar, bg = c.red, bold = true },
    error = { fg = c.red, bg = c.bar },
    error_visible = { fg = c.red, bg = c.bar },
    error_selected = { fg = c.red, bg = c.selection, bold = true },
    warning = { fg = c.yellow, bg = c.bar },
    warning_visible = { fg = c.yellow, bg = c.bar },
    warning_selected = { fg = c.yellow, bg = c.selection, bold = true },
    info = { fg = c.accent, bg = c.bar },
    info_visible = { fg = c.accent, bg = c.bar },
    info_selected = { fg = c.accent, bg = c.selection, bold = true },
    hint = { fg = c.green, bg = c.bar },
    hint_visible = { fg = c.green, bg = c.bar },
    hint_selected = { fg = c.green, bg = c.selection, bold = true },
    tab = { fg = c.border, bg = c.bar },
    tab_selected = { fg = c.text, bg = c.selection, bold = true },
    tab_close = { fg = c.border, bg = c.bar },
  }
end

return {
  -- The actual fix for the reported bug: noice hard-codes `border.style = "none"`
  -- for its hover view, and signature help uses the same view.
  {
    "folke/noice.nvim",
    opts = {
      views = {
        hover = {
          border = { style = "rounded", padding = { 0, 2 } },
          win_options = { winblend = 0, wrap = true, linebreak = true },
        },
      },
    },
  },

  -- blink draws its own windows; make the borders explicit instead of relying
  -- on its `border = nil` fallback.
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = { border = "rounded", winblend = 0 },
        documentation = { window = { border = "rounded", winblend = 0 } },
      },
      signature = {
        enabled = false,
        window = { border = "rounded", winblend = 0 },
      },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      win = {
        border = "rounded",
        wo = { winblend = 0 },
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      -- A function is re-evaluated by lualine's ColorScheme autocommand.
      opts.options.theme = lualine_theme
      opts.options.globalstatus = true
      -- Rounded powerline separators; keeps the bar thin and glassy.
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "", right = "" }
    end,
  },

  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.themable = false
      opts.options.separator_style = "thin"
      opts.options.indicator = { style = "underline", icon = "▎" }
      -- Bufferline re-runs this function on ColorScheme.
      opts.highlights = bufferline_highlights
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    opts = {
      floating = { border = "rounded" },
    },
  },

  {
    "stevearc/aerial.nvim",
    opts = {
      nav = {
        win_opts = { cursorline = true, winblend = 0 },
      },
    },
  },
}
