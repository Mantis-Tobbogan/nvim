-- ============================================================================
-- NEOVIM CONFIGURATION
-- ============================================================================
-- A clean, well-organized Neovim configuration focused on productivity
-- and ease of customization.

-- ============================================================================
-- LEADER KEY CONFIGURATION
-- ============================================================================
-- Set leader keys before loading plugins to ensure proper mapping
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- GENERAL SETTINGS
-- ============================================================================

-- File Explorer (netrw) Configuration
vim.g.netrw_bufsettings = "noma nomod rnu"

-- Font and Icons
vim.g.have_nerd_font = true

-- ============================================================================
-- EDITOR OPTIONS
-- ============================================================================

local opt = vim.opt

-- Line Numbers
opt.number = true
opt.relativenumber = true

-- Mouse Support
opt.mouse = "a"

-- Interface
opt.showmode = false -- Don't show mode (status line shows it)
opt.signcolumn = "yes" -- Always show sign column
opt.cursorline = true -- Highlight current line
opt.scrolloff = 10 -- Keep lines above/below cursor

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.inccommand = "split" -- Live preview for substitutions

-- Indentation
opt.smartindent = true
opt.breakindent = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Undo
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Timing
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = "menuone,noselect"

-- Visual Elements
opt.termguicolors = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "‣" }

-- ============================================================================
-- FILETYPE SPECIFIC SETTINGS
-- ============================================================================

-- HTML and Template Files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = vim.api.nvim_create_augroup("html_template_filetypes", { clear = true }),
	pattern = { "*.gohtml", "*.jinja", "*.mustache", "*.hbs", "*.tmpl", "*.tpl" },
	callback = function()
		vim.bo.filetype = "html"
	end,
	desc = "Set HTML filetype for template files",
})

-- HTML Indentation
vim.api.nvim_create_autocmd("FileType", {
	pattern = "html",
	callback = function()
		local bo = vim.bo
		bo.tabstop = 2
		bo.softtabstop = 2
		bo.shiftwidth = 2
		bo.expandtab = true
	end,
	desc = "Set HTML indentation to 2 spaces",
})

-- Mason Window Settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = "mason",
	callback = function()
		vim.wo.relativenumber = true
	end,
	desc = "Enable relative line numbers in Mason",
})

-- ============================================================================
-- KEY MAPPINGS
-- ============================================================================

local keymap = vim.keymap.set

-- Clear search highlighting
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Diagnostic Navigation
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

-- Custom Diagnostic Functions
local function toggle_diagnostic_float()
	-- Check if diagnostic float is already open
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			vim.api.nvim_win_close(win, true)
			return
		end
	end
	-- Open diagnostic float
	vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
end

local function toggle_loclist()
	-- Check if location list is open
	local loclist_open = false
	for _, win in ipairs(vim.fn.getwininfo()) do
		if win.loclist == 1 then
			loclist_open = true
			break
		end
	end

	if loclist_open then
		vim.cmd("lclose")
	else
		vim.diagnostic.setloclist({ open = true })
	end
end

keymap("n", "<leader>l", toggle_diagnostic_float, { desc = "Toggle diagnostic float" })
-- keymap("n", "<leader>q", toggle_loclist, { desc = "Toggle diagnostic location list" })
keymap("n", "<C-S-m>", toggle_loclist, { desc = "Toggle diagnostic location list" })

-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================

-- Highlight on Yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- ============================================================================
-- LAZY.NVIM SETUP
-- ============================================================================

-- Install lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- PLUGIN CONFIGURATION
-- ============================================================================

require("lazy").setup({
	-- ========================================================================
	-- CORE UTILITIES
	-- ========================================================================

	-- Automatic indentation detection
	{ "NMAC427/guess-indent.nvim" },

	-- ========================================================================
	-- GIT INTEGRATION
	-- ========================================================================

	-- Git commands
	{ "tpope/vim-fugitive" },
	{ "tpope/vim-rhubarb" },

	-- Git signs in gutter
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gs = require("gitsigns")
				keymap("n", "[c", gs.prev_hunk, { buffer = bufnr, desc = "Go to previous hunk" })
				keymap("n", "]c", gs.next_hunk, { buffer = bufnr, desc = "Go to next hunk" })
				keymap("n", "<leader>ph", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
			end,
		},
	},

	-- ========================================================================
	-- USER INTERFACE
	-- ========================================================================

	-- Key binding help
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
			},
			spec = {
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = true,
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_a = { "buffers" },
			},
		},
	},

	-- Indentation guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = "┊",
				smart_indent_cap = true,
			},
			whitespace = { remove_blankline_trail = false },
		},
	},

	-- Required dependency
	{ "nvim-neotest/nvim-nio" },

	-- ========================================================================
	-- FUZZY FINDING
	-- ========================================================================

	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = { ["<c-enter>"] = "to_fuzzy_refine" },
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Load extensions
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- Telescope key mappings
			local builtin = require("telescope.builtin")
			keymap("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			keymap("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			keymap("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			keymap("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			keymap("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			keymap("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			keymap("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			keymap("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			keymap("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			keymap("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- Advanced telescope mappings
			keymap("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			keymap("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			keymap("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	-- ========================================================================
	-- LSP CONFIGURATION
	-- ========================================================================

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			-- LSP Attach Configuration
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						keymap("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Navigation
					map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
					map("gr", require("telescope.builtin").lsp_references, "Goto References")
					map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
					map("gD", vim.lsp.buf.declaration, "Goto Declaration")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")

					-- Symbols
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
					map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

					-- Code Actions
					map("<leader>rn", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

					-- Documentation - Fixed hover configuration
					map("K", function()
						vim.lsp.buf.hover()
					end, "Hover Documentation")

					-- Highlight references
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			-- Enhanced LSP capabilities
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Server Configurations
			local servers = {
				-- Python
				pyright = {
					settings = {
						python = {
							analysis = {
								autoImportCompletions = true,
								autoSearchPath = true,
								diagnosticMode = "workspace",
								typeCheckingMode = "off",
								useLibraryCodeForTypes = true,
								diagnosticSeverityOverrides = {
									reportGeneralTypeIssues = "information",
									reportOptionalMemberAccess = "information",
									reportCallIssue = "error",
									reportInvalidTypeArguments = "error",
									reportArgumentType = "error",
								},
							},
						},
					},
				},

				-- Web Development
				["typescript-language-server"] = {},
				html = {},
				cssls = {},
				emmet_ls = {},

				-- Go
				gopls = {
					settings = {
						gopls = {
							analyses = { unusedparams = true },
							staticcheck = true,
							usePlaceholders = true,
							gofumpt = true,
						},
					},
				},

				-- SQL
				sqlfmt = {},

				-- Lua
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
							},
							completion = { callSnippet = "Replace" },
						},
					},
				},
			}

			-- Setup Mason
			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers)
			vim.list_extend(ensure_installed, {
				"stylua",
				"jsonlint",
				"ruff",
				"goimports",
				"gofumpt",
				"golangci-lint",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			-- Enhanced Diagnostic Configuration
			vim.diagnostic.config({
				virtual_text = false,
				severity_sort = true,
				underline = true,
				update_in_insert = false,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✗", -- Error: Cross mark
						[vim.diagnostic.severity.WARN] = "⚠", -- Warning: Warning triangle
						[vim.diagnostic.severity.INFO] = "ℹ", -- Info: Info circle
						[vim.diagnostic.severity.HINT] = "➤", -- Hint: Arrow
					},
				},
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})

			-- Configure LSP handlers for better presentation
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
				title = "Hover",
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
				title = "Signature Help",
			})
		end,
	},

	-- ========================================================================
	-- CODE FORMATTING
	-- ========================================================================

	{
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters = {
				ruff_fix_custom = {
					command = "ruff",
					args = { "check", "--fix", "--ignore", "F401", "--stdin-filename", "$FILENAME", "-" },
					stdin = true,
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_fix_custom" },
				go = { "goimports", "gofumpt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				markdown = { "prettier" },
				json = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
			},
		},
	},

	-- ========================================================================
	-- AUTOCOMPLETION
	-- ========================================================================

	{
		"saghen/blink.cmp",
		version = "1.*",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end,
			},
		},
		config = function()
			local blink = require("blink.cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			blink.setup({
				snippets = { preset = "luasnip" },
				keymap = {
					preset = "default",
					["<C-n>"] = { "select_next", "fallback" },
					["<C-p>"] = { "select_prev", "fallback" },
					["<C-y>"] = { "accept", "fallback" },
					["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
					["<C-l>"] = { "snippet_forward", "fallback" },
					["<C-h>"] = { "snippet_backward", "fallback" },
				},
				sources = {
					default = { "lsp", "path", "snippets" },
					providers = {
						lsp = { name = "LSP", module = "blink.cmp.sources.lsp" },
						path = { name = "Path", module = "blink.cmp.sources.path", score_offset = -3 },
						snippets = { name = "Snippets", module = "blink.cmp.sources.snippets", score_offset = -1 },
					},
				},
				completion = {
					accept = { auto_brackets = { enabled = true } },
					menu = {
						enabled = true,
						min_width = 15,
						max_height = 10,
						border = "shadow",
						winblend = 15, -- Match your original opacity
						winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
						scrolloff = 2,
						scrollbar = true,
						direction_priority = { "s", "n" },
						auto_show = true,
						draw = {
							columns = {
								{ "kind_icon", "label", gap = 1 },
								{ "kind" },
							},
						},
					},
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 500,
						update_delay_ms = 50,
						treesitter_highlighting = true,
						window = {
							min_width = 10,
							max_width = 80,
							max_height = 20,
							border = "rounded",
							winblend = 10, -- Add transparency
							winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
							scrollbar = true,
							direction_priority = {
								menu_north = { "e", "w", "n", "s" },
								menu_south = { "e", "w", "s", "n" },
							},
						},
					},
					ghost_text = {
						enabled = true,
						show_with_selection = true,
						show_without_selection = false,
						show_with_menu = true,
						show_without_menu = false,
					},
				},
				signature = {
					enabled = true,
					window = {
						min_width = 1,
						max_width = 100,
						max_height = 10,
						border = "rounded",
						winblend = 10, -- Add transparency
						winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
						scrollbar = false,
						direction_priority = { "n", "s" },
						treesitter_highlighting = true,
						show_documentation = true,
					},
				},
				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
				},
			})
		end,
	},

	-- ========================================================================
	-- CODE ENHANCEMENT
	-- ========================================================================

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	-- Mini utilities
	{
		"echasnovski/mini.nvim",
		config = function()
			-- Text objects
			require("mini.ai").setup({ n_lines = 500 })

			-- Surround operations
			require("mini.surround").setup()

			-- Status line (alternative to lualine if preferred)
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},

	-- ========================================================================
	-- SYNTAX HIGHLIGHTING
	-- ========================================================================

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"html",
					"lua",
					"markdown",
					"vim",
					"vimdoc",
					"python",
					"toml",
					"go",
					"gomod",
					"json",
					"javascript",
					"typescript",
					"css",
					"yaml",
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})
		end,
	},

	-- Auto-close HTML/XML tags
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	-- ========================================================================
	-- CUSTOM PLUGINS
	-- ========================================================================
	-- Import additional custom plugins from lua/custom/plugins/
	{ import = "custom.plugins" },
})

-- ============================================================================
-- POST-PLUGIN CONFIGURATION
-- ============================================================================

-- Any additional configuration that needs to run after plugins are loaded
-- can be added here.

-- Example: Set colorscheme (uncomment and modify as needed)
-- vim.cmd.colorscheme('your-preferred-colorscheme')

-- ============================================================================
-- END OF CONFIGURATION
-- ============================================================================
