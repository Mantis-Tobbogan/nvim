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
				"yaml",
				"markdown",
				"css",
				"javascript",
				"typescript",
				"vue",
			},
		}),
		b.formatting.remark, -- Markdown

		-- Spellcheck
		b.completion.spell,

		-- CMake
		b.formatting.cmake_format,

		-- Code actions (requires gitsigns.nvim)
		b.code_actions.gitsigns,
	}

	-- none-ls setup
	none_ls.setup({
		debug = false,
		sources = sources,
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				-- Create the augroup first, then clear any existing autocmds for this buffer
				local augroup = vim.api.nvim_create_augroup("LspFormat", { clear = false })
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr })
					end,
				})
			end
		end,
	})
end

-- Separate Ruff LSP configuration (should be in a separate file or LSP config)
function M.setup_ruff_lsp()
	local lspconfig = require("lspconfig")
	lspconfig.ruff_lsp.setup({
		init_options = {
			settings = {
				args = {
					"--config=" .. vim.fn.expand("~/.config/ruff.toml"),
					"--line-length=120",
					"--select=B,C,E,F,W,T4,B9,I001",
				},
			},
		},
		on_attach = function(client, bufnr)
			-- Disable hover in favor of other LSPs (like pyright)
			client.server_capabilities.hoverProvider = false

			-- Format on save
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = "RuffFormat", buffer = bufnr })
				vim.api.nvim_create_augroup("RuffFormat", { clear = false })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = "RuffFormat",
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr, name = "ruff_lsp" })
					end,
				})
			end
		end,
	})
end

return M
