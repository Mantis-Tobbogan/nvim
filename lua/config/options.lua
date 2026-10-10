-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Make mise-managed CLI tools (prettier, node, ...) visible to Neovim even when
-- it is launched outside an interactive shell (e.g. from a GUI/launcher).
local mise_shims = vim.fn.expand("~/.local/share/mise/shims")
if vim.fn.isdirectory(mise_shims) == 1 and not vim.env.PATH:find(mise_shims, 1, true) then
  vim.env.PATH = mise_shims .. ":" .. vim.env.PATH
end

-- NOTE: do NOT set `vim.opt.clipboard` here. LazyVim already configures it
-- correctly: `unnamedplus`, or empty over SSH so the built-in OSC52 provider
-- takes over. Overriding it breaks "yank over SSH".

vim.opt.guifont = "CaskaydiaCove Nerd Font:h12"
vim.opt.linespace = 3
vim.opt.relativenumber = true -- Force relative numbers everywhere
vim.opt.termguicolors = true
vim.opt.numberwidth = 1 -- Smallest width possible

-- More context around the cursor (closer to how Zed/VSCode feel).
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 12

-- Rounded borders on hover/signature/diagnostic/float windows (nvim 0.11+).
vim.o.winborder = "rounded"

-- Theme, transparency and the :Theme command.
require("config.theme").setup()
