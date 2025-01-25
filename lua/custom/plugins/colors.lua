--"folke/tokyonight.nvim",
--local M = {
--lazy = false,
--priority = 1000,
--opts = {},
--config = function()
--Color = Color or 'tokyonight-night'
--vim.cmd.colorscheme(Color)
--vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
--vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
--end,
--}

local M = {
  'rose-pine/neovim',
  name = 'rose-pine',
  config = function()
    Color = Color or 'rose-pine'
    vim.cmd.colorscheme(Color)
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  end,
}

return M
