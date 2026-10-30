-- Glass UI: frosted surfaces for floats/menus, rounded borders everywhere,
-- and a Catppuccin-tinted chrome.
--
-- The tint colours are read from the active theme so the bars still look right
-- if you try another colorscheme; the terminal/tmux chrome intentionally stays
-- Catppuccin. Keep the alpha hexes in sync with kitty.conf and .tmux.conf:
--   #181825 mantle   @ 0.86 (floats, menus, sidebars)
--   #11111b crust    @ 0.80 (lualine, winbar, tmux status, kitty tabs)
--   #313244 surface0 @ 0.72 (selected completion/tab)

local function color(name, attr, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  local value = ok and hl[attr] or nil
  if type(value) == "number" then
    return string.format("#%06x", value)
  end
  return fallback
end

local function palette()
  return {
    mantle = color("NormalFloat", "bg", "#181825"),
    crust = color("NormalSB", "bg", "#11111b"),
    surface0 = color("PmenuSel", "bg", "#313244"),
    surface1 = color("WinSeparator", "fg", "#45475a"),
    overlay0 = color("FloatBorder", "fg", "#6c7086"),
    text = color("Normal", "fg", "#cdd6f4"),
    subtext0 = color("NormalNC", "fg", "#a6adc8"),
    accent = color("FloatTitle", "fg", "#b4befe"),
    green = color("String", "fg", "#a6e3a1"),
    yellow = color("DiagnosticWarn", "fg", "#f9e2af"),
    red = color("DiagnosticError", "fg", "#f38ba8"),
    mauve = color("Statement", "fg", "#cba6f7"),
  }
end

local function lualine_theme()
  local p = palette()
  local section = {
    a = { fg = p.crust, bg = p.accent, gui = "bold" },
    b = { fg = p.text, bg = p.crust },
    c = { fg = p.subtext0, bg = p.crust },
  }
  local inactive = { fg = p.overlay0, bg = p.crust }

  return {
    normal = section,
    insert = { a = { fg = p.crust, bg = p.green, gui = "bold" }, b = section.b, c = section.c },
    visual = { a = { fg = p.crust, bg = p.mauve, gui = "bold" }, b = section.b, c = section.c },
    replace = { a = { fg = p.crust, bg = p.red, gui = "bold" }, b = section.b, c = section.c },
    command = { a = { fg = p.crust, bg = p.yellow, gui = "bold" }, b = section.b, c = section.c },
    terminal = { a = { fg = p.crust, bg = p.green, gui = "bold" }, b = section.b, c = section.c },
    inactive = { a = inactive, b = inactive, c = inactive },
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
      opts.options.theme = lualine_theme()
      opts.options.globalstatus = true
      -- Rounded powerline separators; keeps the bar thin and glassy.
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "", right = "" }
    end,
  },

  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      local p = palette()
      opts.options = opts.options or {}
      opts.options.themable = false
      opts.options.separator_style = "thin"
      opts.options.indicator = { style = "underline", icon = "▎" }
      opts.highlights = {
        fill = { bg = p.crust },
        background = { fg = p.overlay0, bg = p.crust },
        buffer = { fg = p.overlay0, bg = p.crust },
        buffer_visible = { fg = p.subtext0, bg = p.crust },
        buffer_selected = { fg = p.text, bg = p.surface0, bold = true, italic = false },
        numbers = { fg = p.overlay0, bg = p.crust },
        numbers_visible = { fg = p.overlay0, bg = p.crust },
        numbers_selected = { fg = p.text, bg = p.surface0, bold = true },
        close_button = { fg = p.overlay0, bg = p.crust },
        close_button_visible = { fg = p.overlay0, bg = p.crust },
        close_button_selected = { fg = p.red, bg = p.surface0 },
        modified = { fg = p.yellow, bg = p.crust },
        modified_visible = { fg = p.yellow, bg = p.crust },
        modified_selected = { fg = p.yellow, bg = p.surface0 },
        duplicate = { fg = p.yellow, bg = p.crust },
        duplicate_visible = { fg = p.yellow, bg = p.crust },
        duplicate_selected = { fg = p.yellow, bg = p.surface0, bold = true },
        separator = { fg = p.surface1, bg = p.crust },
        separator_visible = { fg = p.surface1, bg = p.crust },
        separator_selected = { fg = p.surface0, bg = p.crust },
        offset_separator = { fg = p.surface1, bg = p.crust },
        indicator_selected = { fg = p.accent, bg = p.surface0 },
        indicator_visible = { fg = p.overlay0, bg = p.crust },
        pick = { fg = p.crust, bg = p.accent, bold = true },
        pick_visible = { fg = p.crust, bg = p.yellow, bold = true },
        pick_selected = { fg = p.crust, bg = p.red, bold = true },
        error = { fg = p.red, bg = p.crust },
        error_visible = { fg = p.red, bg = p.crust },
        error_selected = { fg = p.red, bg = p.surface0, bold = true },
        warning = { fg = p.yellow, bg = p.crust },
        warning_visible = { fg = p.yellow, bg = p.crust },
        warning_selected = { fg = p.yellow, bg = p.surface0, bold = true },
        info = { fg = p.accent, bg = p.crust },
        info_visible = { fg = p.accent, bg = p.crust },
        info_selected = { fg = p.accent, bg = p.surface0, bold = true },
        hint = { fg = p.green, bg = p.crust },
        hint_visible = { fg = p.green, bg = p.crust },
        hint_selected = { fg = p.green, bg = p.surface0, bold = true },
        tab = { fg = p.overlay0, bg = p.crust },
        tab_selected = { fg = p.text, bg = p.surface0, bold = true },
        tab_close = { fg = p.overlay0, bg = p.crust },
      }
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
