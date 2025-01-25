local keymap = vim.keymap.set
local opts = { noremap = true, silent = true}

-- remap leader key
keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- yank to system clipboard
keymap({"n", "v"}, "<leader>y", '"+y', opts)

-- paste from system clipboard
keymap({"n", "v"}, "<leader>p", '"+p', opts)

-- better indent handling
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- move text up and down
keymap("v", "J", ":m .+1<CR>==", opts)
keymap("v", "K", ":m .-2<CR>==", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- paste preserves primal yanked piece
keymap("v", "p", '"_dP', opts)

-- removes highlighting after escaping vim search
keymap("n", "<Esc>", "<Esc>:noh<CR>", opts)
vim.o.hlsearch = false

--------------- VSCODE Bindings ------------------------------------
-- Show Hover during `insert` mode. (Shift-k is default) NOTE: Make it for your own neovim as well
keymap({"i"}, "<C-k>i", "<cmd>lua require('vscode').action('editor.action.showHover')")

-- Format Document
keymap({"n", "v"}, "<leader>fd", "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>")

-- Trigger Parameter Hints inside a method or function call
keymap({"n", "i"}, "<C-S-space>", "<cmd>lua require('vscode').action('editor.action.triggerParameterHints')<CR>")

-- Search files (Called QuickOpen in VSCode)
keymap({"n", "v"}, "<leader>sf", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>")

-- Copy to System ClipBoard
keymap({"n", "v", "i"}, "<C-c>", "<cmd>lua require('vscode').action('editor.action.clipboardCopyAction')<CR>")

-- QuickFix
keymap({"n", "v"}, "<leader>.", "<cmd>lua require('vscode').action('editor.action.quickFix')<CR>")

-- Accept suggestion for autocomplete (not working) 
vim.api.nvim_set_keymap("n", "<C-y>", "<cmd>lua require('vscode').action('acceptSelectedSuggestion')<CR>", { noremap = true, silent = true })
-- Accept suggestion for autocomplete (not working) 
vim.api.nvim_set_keymap("i", "<C-y>", "<cmd>lua require('vscode').action('acceptSelectedSuggestion')<CR>", { noremap = true, silent = true })
-------------- MY THING --------------------------------------------

