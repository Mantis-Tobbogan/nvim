local M = {
	vim.keymap.set("n", "<leader>pv", vim.cmd.Ex),
	vim.keymap.set("n", "<leader>e", vim.cmd.Ex),

	vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv"),
	vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv"),

	vim.keymap.set("n", "J", "mzJ`z"),
	vim.keymap.set("n", "<C-d>", "<C-d>zz"),
	vim.keymap.set("n", "<C-u>", "<C-u>zz"),
	vim.keymap.set("n", "n", "nzzzv"),
	vim.keymap.set("n", "N", "Nzzzv"),
	vim.keymap.set("n", "<C-l><C-l>", ":set invrelativenumber<CR>"),
	vim.keymap.set("n", "[b", "<cmd>bprev<CR>", { desc = "Previous buffer" }),
	vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" }),
	vim.keymap.set("n", "<leader>bc", "<cmd>bdelete<CR>", { desc = "Delete current buffer" }),

	--vim.keymap.set("x", "<leader>P", [["_dP]], { desc = "Paste from the clipboard" }),
	-- vim.keymap.set("x", "<leader>P", [["+p]], { desc = "Paste from the clipboard" }),

	-- next greatest remap ever : asbjornHaland
	--vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]]),
	vim.keymap.set({ "n", "v" }, "<C-c>", [["+y]]),
	--vim.keymap.set("n", "<leader>Y", [["+Y]]),
	vim.keymap.set("n", "<C-c>", [["+Y]]),

	vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]]),

	-- This is going to get me cancelled
	vim.keymap.set("i", "<C-c>", "<Esc>"),

	vim.keymap.set("n", "Q", "<nop>"),
	-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>"),
	vim.keymap.set("n", "<A-S-f>", vim.lsp.buf.format),

	-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz"),
	-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz"),
	vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz"),
	vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz"),
	vim.keymap.set("n", "<leader>sub", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]),
	vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }),
	vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton game_of_life<CR>"),

	-- From chris@scratcher --
	-- Stay in visual indent mode
	vim.keymap.set("v", "<", "<gv", { silent = true }),
	vim.keymap.set("v", ">", ">gv", { silent = true }),

	-- Resize with arrows
	vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", { silent = true }),
	vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", { silent = true }),
	vim.keymap.set("n", "<C-Left>", ":vertical resize +2<CR>", { silent = true }),
	vim.keymap.set("n", "<C-Right>", ":vertical resize -2<CR>", { silent = true }),

	-- Custom LSP related
	vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help),

	-- Remap for dealing with word wrap
	vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true }),
	vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true }),

	-- Keymaps for better default experience
	-- See `:help vim.keymap.set()`
	vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true }),
}

return M
