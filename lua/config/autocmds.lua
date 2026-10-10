-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Prevent comment continuation globally
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- Force relative numbers on every window as possible
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "CmdlineLeave", "FocusGained", "InsertLeave", "WinEnter" }, {
  pattern = "*",
  callback = function()
    if vim.o.relativenumber == false then
      vim.opt.relativenumber = true
      vim.opt.number = true
    end
  end,
})

vim.api.nvim_create_autocmd("WinNew", {
  callback = function()
    vim.wo.number = true
    vim.wo.relativenumber = true
  end,
})

-- Go uses tabs (gofmt). LazyVim's global tabstop is 2, which makes Go look
-- 2-wide; show tabs as 4 columns instead. shiftwidth=0 follows tabstop.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 0
    vim.opt_local.softtabstop = 0
  end,
})

-- Load language-specific DAP launch configurations on demand, instead of from
-- nvim-dap's `config` (which LazyVim's dap.core owns). `vim.schedule` makes
-- sure it runs after startup / VeryLazy, even when Neovim is opened directly
-- with a file.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  once = true,
  callback = function()
    vim.schedule(function()
      require("config.dap.python")
    end)
  end,
})
