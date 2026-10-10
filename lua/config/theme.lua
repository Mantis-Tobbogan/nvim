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
  default_theme = "catppuccin-mocha",
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
  -- Core UI
  "Normal",
  "NormalFloat",
  "NormalNC",
  "FloatBorder",
  "Pmenu",
  "Terminal",
  "EndOfBuffer",
  "FoldColumn",
  "Folded",
  "SignColumn",
  "WhichKeyFloat",
  -- Telescope
  "TelescopeBorder",
  "TelescopeNormal",
  "TelescopePromptBorder",
  "TelescopePromptTitle",
  -- neo-tree
  "NeoTreeNormal",
  "NeoTreeNormalNC",
  "NeoTreeVertSplit",
  "NeoTreeWinSeparator",
  "NeoTreeEndOfBuffer",
  -- nvim-tree
  "NvimTreeNormal",
  "NvimTreeVertSplit",
  "NvimTreeEndOfBuffer",
  -- snacks.nvim notifier
  "NotifyINFOBody",
  "NotifyERRORBody",
  "NotifyWARNBody",
  "NotifyTRACEBody",
  "NotifyDEBUGBody",
  "NotifyINFOTitle",
  "NotifyERRORTitle",
  "NotifyWARNTitle",
  "NotifyTRACETitle",
  "NotifyDEBUGTitle",
  "NotifyINFOBorder",
  "NotifyERRORBorder",
  "NotifyWARNBorder",
  "NotifyTRACEBorder",
  "NotifyDEBUGBorder",
}

local function apply_transparency()
  if not M.config.transparent then
    return
  end
  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("UserTheme", { clear = true }),
    callback = apply_transparency,
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
