-- lua/plugins/none-ls.lua
local M = {
	"nvimtools/none-ls.nvim",
	event = "BufReadPre",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvimtools/none-ls-extras.nvim", -- for additional builtins support
	},
}

function M.config()
	local none_ls = require("null-ls")
	local b = none_ls.builtins

	-- Define none-ls sources
	local sources = {
		-- Formatting
		b.formatting.stylua, -- Lua
		b.formatting.prettier.with({
			filetypes = {
				"html",
				"json",
				"jsonc",
				"yaml",
				"markdown",
				"css",
				"javascript",
				"typescript",
				"vue",
			},
		}),

		-- CMake
		b.formatting.cmake_format,

		-- Code actions (requires gitsigns.nvim)
		b.code_actions.gitsigns,

		-- Go
		b.diagnostics.golangci_lint,

		-- -- Python
		-- b.diagnostics.ruff,
	}

	-- none-ls setup
	none_ls.setup({
		debug = false,
		sources = sources,
		on_attach = function(client, bufnr)
			-- if client.supports_method("textDocument/formatting") then
			if client:supports_method("textDocument/formatting") then
				-- Create the augroup first, then clear any existing autocmds for this buffer
				local augroup = vim.api.nvim_create_augroup("LspFormat", { clear = false })
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						local view = vim.fn.winsaveview()
						vim.lsp.buf.format({ bufnr = bufnr })
						vim.fn.winrestview(view)
					end,
				})
			end
		end,
	})
end

-- Separate Ruff LSP configuration (should be in a separate file or LSP config)
return M
