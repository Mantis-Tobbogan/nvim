-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- This file is the *Neovim side* of the shared keymap spec
-- (../keymaps.json). VSCode and Zed are ports of the same table, so a key
-- means the same thing in all three editors.
-- Run `python3 scripts/check-parity.py` to verify all three.

-- ---------------------------------------------------------------------------
-- Clipboard
--
-- Neovim keeps its registers separate from the system clipboard
-- (see lua/config/options.lua: vim.opt.clipboard = ""), so the crossing
-- points are explicit:
--   <C-c>     yank to the system clipboard
--   <C-S-v>   paste from the system clipboard
-- ---------------------------------------------------------------------------
vim.keymap.set({ "n", "v" }, "<C-c>", [["+y]])
vim.keymap.set("n", "<C-c>", [["+Y]])
vim.keymap.set("n", "<C-S-v>", [["+P]])

-- ---------------------------------------------------------------------------
-- Explorer panel
--
-- LazyVim binds <leader>E to "neo-tree in the cwd". The shared spec uses
-- <leader>E for "toggle the explorer panel" (VSCode: toggle sidebar,
-- Zed: toggle left dock). <leader>fE keeps the LazyVim behaviour, so
-- nothing is lost.
-- ---------------------------------------------------------------------------
vim.keymap.set("n", "<leader>E", function()
  require("neo-tree.command").execute({ action = "toggle", source = "current" })
end, { desc = "Toggle Explorer Panel" })
