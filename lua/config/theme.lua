-- Central theme configuration.
--
-- Change `default_theme` below to switch the default. The colorscheme plugins
-- themselves live in lua/plugins/colorscheme.lua.
--
-- This module is loaded from lua/config/options.lua so the transparent
-- highlights and the :Theme command are registered before the colorscheme is
-- applied at startup.
local M = {}

M.config = {
  default_theme = "kanagawa-wave",
  transparent = true,
}

-- Every theme that can be selected with `:Theme <name>`.
M.themes = {
  "kanagawa",
  "kanagawa-wave",
  "kanagawa-dragon",
  "kanagawa-lotus",
  "tokyonight",
  "tokyonight-night",
  "tokyonight-storm",
  "tokyonight-day",
  "tokyonight-moon",
  "catppuccin",
  "catppuccin-latte",
  "catppuccin-frappe",
  "catppuccin-macchiato",
  "catppuccin-mocha",
  "gruvbox",
  "rose-pine",
  "rose-pine-moon",
  "rose-pine-dawn",
  "nord",
  "bamboo",
  "monokai-pro",
}

-- Highlight groups that get a transparent background when
-- M.config.transparent is true.
local transparent_groups = {
  -- Only surfaces that should show the blurred wallpaper. Floats, menus,
  -- sidebars and bars get the theme-neutral glass surfaces in apply_glass.
  "Normal",
  "NormalNC",
  "Terminal",
  "EndOfBuffer",
  "FoldColumn",
  "Folded",
  "SignColumn",
}

local function apply_transparency()
  if not M.config.transparent then
    return
  end
  for _, group in ipairs(transparent_groups) do
    -- Preserve the theme's foreground/style: nvim_set_hl replaces the whole
    -- group, so setting only { bg = "none" } would wipe the colors.
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    hl.bg = "none"
    hl.link = nil
    vim.api.nvim_set_hl(0, group, hl)
  end
end

-- Theme-neutral glass. The surfaces stay the same across colorschemes; only
-- text, borders and accents are read from the active theme. These hex values
-- must also be in kitty.conf's transparent_background_colors.
local glass_dark = { float = "#15151f", bar = "#0f0f17", selection = "#2a2a3a" }
local glass_light = { float = "#f2f2f7", bar = "#e8e8ef", selection = "#d8d8e2" }

local function get_hl(name, attr, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  local value = ok and hl[attr] or nil
  if type(value) == "number" then
    return "#" .. string.format("%06x", value)
  end
  return fallback
end

function M.glass()
  return vim.o.background == "light" and glass_light or glass_dark
end

function M.chrome()
  local g = M.glass()
  local text = get_hl("Normal", "fg", "#cdd6f4")
  return {
    float = g.float,
    bar = g.bar,
    selection = g.selection,
    text = text,
    border = get_hl("Comment", "fg", get_hl("NonText", "fg", "#6c7086")),
    accent = get_hl("Title", "fg", get_hl("Special", "fg", text)),
    green = get_hl("String", "fg", "#a6e3a1"),
    yellow = get_hl("DiagnosticWarn", "fg", "#f9e2af"),
    red = get_hl("DiagnosticError", "fg", "#f38ba8"),
    mauve = get_hl("Statement", "fg", get_hl("Function", "fg", text)),
  }
end

local function apply_glass()
  local c = M.chrome()
  local function set(name, attrs)
    vim.api.nvim_set_hl(0, name, attrs)
  end

  set("NormalFloat", { fg = c.text, bg = c.float })
  set("FloatBorder", { fg = c.border, bg = c.float })
  set("FloatTitle", { fg = c.accent, bg = c.float, bold = true })

  set("Pmenu", { fg = c.text, bg = c.float })
  set("PmenuBorder", { fg = c.border, bg = c.float })
  set("PmenuSel", { fg = c.text, bg = c.selection, bold = true })
  set("PmenuKind", { fg = c.accent, bg = c.float })
  set("PmenuKindSel", { fg = c.accent, bg = c.selection, bold = true })
  set("PmenuExtra", { fg = c.border, bg = c.float })
  set("PmenuExtraSel", { fg = c.border, bg = c.selection, bold = true })
  set("PmenuSbar", { bg = c.selection })
  set("PmenuThumb", { bg = c.border })

  -- blink.cmp maps these explicitly; without definitions the border disappears.
  set("BlinkCmpMenu", { link = "Pmenu" })
  set("BlinkCmpMenuBorder", { link = "PmenuBorder" })
  set("BlinkCmpDoc", { link = "NormalFloat" })
  set("BlinkCmpDocBorder", { link = "FloatBorder" })
  set("BlinkCmpSignatureHelp", { link = "NormalFloat" })
  set("BlinkCmpSignatureHelpBorder", { link = "FloatBorder" })

  set("WinBar", { fg = c.text, bg = c.bar })
  set("WinBarNC", { fg = c.border, bg = c.bar })
  set("WinSeparator", { fg = c.border, bg = "NONE" })
  set("VertSplit", { link = "WinSeparator" })
  set("NormalSB", { fg = c.text, bg = c.bar })

  set("NeoTreeNormal", { fg = c.text, bg = c.float })
  set("NeoTreeNormalNC", { fg = c.text, bg = c.float })
  set("NeoTreeWinSeparator", { fg = c.border, bg = c.float })
  set("NeoTreeStatusLineNC", { fg = c.border, bg = c.float })
  set("NeoTreeTabActive", { fg = c.accent, bg = c.float, bold = true })
  set("NeoTreeTabInactive", { fg = c.border, bg = c.bar })
  set("NeoTreeTabSeparatorActive", { fg = c.float, bg = c.float })
  set("NeoTreeTabSeparatorInactive", { fg = c.bar, bg = c.bar })

  set("TroubleNormal", { fg = c.text, bg = c.bar })
  set("TroubleNormalNC", { fg = c.border, bg = c.bar })
  set("WhichKeyFloat", { fg = c.text, bg = c.float })
  set("WhichKeyBorder", { fg = c.border, bg = c.float })

  set("NoicePopup", { link = "NormalFloat" })
  set("NoicePopupBorder", { link = "FloatBorder" })
  set("NoiceCmdlinePopup", { link = "NormalFloat" })
  set("NoiceCmdlinePopupBorder", { fg = c.accent, bg = c.float })
  set("NoiceCmdlinePopupTitle", { fg = c.accent, bg = c.float, bold = true })
  set("NoiceConfirm", { link = "NormalFloat" })
  set("NoiceConfirmBorder", { fg = c.accent, bg = c.float })

  set("SnacksPicker", { link = "NormalFloat" })
  set("SnacksPickerBorder", { link = "FloatBorder" })
  set("SnacksPickerInput", { link = "NormalFloat" })
  set("SnacksPickerInputBorder", { link = "FloatBorder" })
  set("LazyNormal", { link = "NormalFloat" })
  set("MiniFilesNormal", { link = "NormalFloat" })
  set("MiniFilesBorder", { link = "FloatBorder" })
  set("MiniFilesBorderModified", { fg = c.yellow, bg = c.float })

  set("StatusLine", { fg = c.text, bg = c.bar })
  set("StatusLineNC", { fg = c.border, bg = c.bar })
  set("TabLine", { fg = c.border, bg = c.bar })
  set("TabLineFill", { bg = c.bar })
  set("TabLineSel", { fg = c.text, bg = c.selection, bold = true })

  local nc = vim.api.nvim_get_hl(0, { name = "NormalNC", link = false })
  nc.fg = c.border
  nc.bg = "none"
  nc.link = nil
  set("NormalNC", nc)
end

function M.setup()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("UserTheme", { clear = true }),
    callback = function()
      apply_transparency()
      apply_glass()
    end,
  })

  vim.api.nvim_create_user_command("Theme", function(opts)
    if opts.args == "" then
      vim.notify("Available themes:\n  " .. table.concat(M.themes, "\n  "), vim.log.levels.INFO)
      return
    end
    vim.cmd.colorscheme(opts.args)
  end, {
    nargs = "?",
    desc = "Switch color scheme",
    complete = function(_, line)
      return vim.tbl_filter(function(t)
        return t:find(line, 1, true) == 1
      end, M.themes)
    end,
  })
end

return M
