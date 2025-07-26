local M = {
	"numToStr/Comment.nvim",
	opts = {
		-- You can add any global options here
		-- Example:
		-- mappings = false, -- disable default keymaps
		-- ignore = nil,     -- list of filetypes to ignore
	},
	lazy = false,
}

function M.config()
	local comment = require("Comment")

	-- Setup Comment.nvim
	comment.setup({
		-- Disable default mappings since we're setting custom ones
		mappings = {
			basic = false,
			extra = false,
		},
		-- Optional: Customize comment style for different filetypes
		-- Example: Add support for Python-style comments
		-- [ "python" ] = { "## ", "## " }, -- or whatever you prefer
	})

	local api = require("Comment.api")

	-- VSCode-like keymaps for line and visual comment toggle
	vim.keymap.set("n", "<C-/>", function()
		api.toggle.linewise.current()
	end, { desc = "Toggle comment (line)" })

	-- For visual mode, we need to use a different approach
	vim.keymap.set("x", "<C-/>", function()
		local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
		vim.api.nvim_feedkeys(esc, "nx", false)
		api.toggle.linewise(vim.fn.visualmode())
	end, { desc = "Toggle comment (visual)" })

	-- VSCode-like block comment toggle (Ctrl+Shift+A)
	vim.keymap.set("n", "<C-S-/>", function()
		api.toggle.blockwise.current()
	end, { desc = "Toggle block comment (normal)" })

	vim.keymap.set("x", "<C-S-/>", function()
		local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
		vim.api.nvim_feedkeys(esc, "nx", false)
		api.toggle.blockwise(vim.fn.visualmode())
	end, { desc = "Toggle block comment (visual)" })

	-- Alternative keymaps that might work better in your terminal
	-- (Some terminals don't handle Ctrl+/ or Ctrl+Shift combinations well)
	vim.keymap.set("n", "gcc", function()
		api.toggle.linewise.current()
	end, { desc = "Toggle comment (line)" })

	vim.keymap.set("n", "gbc", function()
		api.toggle.blockwise.current()
	end, { desc = "Toggle block comment (normal)" })

	vim.keymap.set("x", "gc", function()
		local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
		vim.api.nvim_feedkeys(esc, "nx", false)
		api.toggle.linewise(vim.fn.visualmode())
	end, { desc = "Toggle comment (visual)" })

	vim.keymap.set("x", "gb", function()
		local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
		vim.api.nvim_feedkeys(esc, "nx", false)
		api.toggle.blockwise(vim.fn.visualmode())
	end, { desc = "Toggle block comment (visual)" })
end

return M
