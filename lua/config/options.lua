-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.guifont = "CaskaydiaCove Nerd Font:h12"
vim.opt.linespace = 3
vim.opt.relativenumber = true -- Force relative numbers everywhere
vim.opt.termguicolors = true
vim.opt.numberwidth = 1 -- Smallest width possible

-- Lua
vim.opt.clipboard = "unnamed"

-- Transparency settings - applied to all themes
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- Check if transparency is enabled in theme config
    local transparent = _G.theme_config and _G.theme_config.transparent or true

    if transparent then
      -- Core UI elements
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
      vim.api.nvim_set_hl(0, "Terminal", { bg = "none" })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
      vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })
      vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
      vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "none" })

      -- Telescope
      vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "none" })

      -- NeoTree
      vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeVertSplit", { bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none" })

      -- NvimTree
      vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { bg = "none" })
      vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

      -- Notify
      vim.api.nvim_set_hl(0, "NotifyINFOBody", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyERRORBody", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyWARNBody", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyTRACEBody", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyINFOTitle", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyERRORTitle", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyWARNTitle", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyTRACETitle", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyINFOBorder", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyERRORBorder", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyWARNBorder", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { bg = "none" })
      vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { bg = "none" })
    end
  end,
})

-- Theme command for runtime switching (session only)
vim.api.nvim_create_user_command("Theme", function(opts)
  local theme = opts.args
  if theme == "" then
    vim.notify(
      "Available themes:\n" ..
      "  kanagawa, kanagawa-wave, kanagawa-dragon, kanagawa-lotus\n" ..
      "  tokyonight, tokyonight-night, tokyonight-storm, tokyonight-day, tokyonight-moon\n" ..
      "  catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha\n" ..
      "  gruvbox, rose-pine, rose-pine-moon, rose-pine-dawn\n" ..
      "  nord, bamboo, monokai-pro",
      vim.log.levels.INFO
    )
    return
  end
  vim.cmd.colorscheme(theme)
end, {
  nargs = "?",
  complete = function(_, line)
    local themes = {
      "kanagawa", "kanagawa-wave", "kanagawa-dragon", "kanagawa-lotus",
      "tokyonight", "tokyonight-night", "tokyonight-storm", "tokyonight-day", "tokyonight-moon",
      "catppuccin", "catppuccin-latte", "catppuccin-frappe", "catppuccin-macchiato", "catppuccin-mocha",
      "gruvbox",
      "rose-pine", "rose-pine-moon", "rose-pine-dawn",
      "nord",
      "bamboo",
      "monokai-pro",
    }
    return vim.tbl_filter(function(t) return t:find(line, 1, true) end, themes)
  end
})
