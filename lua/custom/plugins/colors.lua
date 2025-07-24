--[[ local M = {
	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
		Color = Color or "rose-pine"
		vim.cmd.colorscheme(Color)
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	end,
} ]]

local M = {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	dependencies = { "nvim-lualine/lualine.nvim" }, -- Add lualine as a dependency
	config = function()
		-- Clear all existing highlights to prevent Tokyo Night bleed-through
		vim.cmd("highlight clear")
		if vim.fn.exists("syntax_on") then
			vim.cmd("syntax reset")
		end

		require("kanagawa").setup({
			compile = false, -- Enable compiling the colorscheme (set to true if you want faster startup after config changes, then run :KanagawaCompile)
			undercurl = true, -- Enable undercurls for errors/warnings
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = true, -- Do not set background color
			dimInactive = false, -- Dim inactive windows
			terminalColors = true, -- Define vim.g.terminal_color_{0,17}
			colors = {
				palette = {},
				theme = {
					wave = {},
					lotus = {},
					dragon = {},
					all = {
						ui = {
							float = { bg = "none" }, -- Transparent floating windows
							bg_gutter = "none", -- Transparent line number background
						},
					},
				},
			},
			overrides = function(colors)
				local theme = colors.theme
				-- Helper function to create 10% opacity borders
				local function blend_border(color)
					return require("kanagawa.lib.color")(color):blend(theme.ui.bg, 0.1):to_hex()
				end
				return {
					-- Telescope customizations with borders
					TelescopeTitle = { fg = theme.ui.special, bold = true },
					TelescopePromptNormal = { bg = theme.ui.bg_p1 },
					TelescopePromptBorder = { fg = blend_border(theme.ui.bg_p1), bg = theme.ui.bg_p1 },
					TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
					TelescopeResultsBorder = { fg = blend_border(theme.ui.bg_m1), bg = theme.ui.bg_m1 },
					TelescopePreviewNormal = { bg = theme.ui.bg_dim },
					TelescopePreviewBorder = { fg = blend_border(theme.ui.bg_dim), bg = theme.ui.bg_dim },

					-- Popup menu (Pmenu) for completion
					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },
					PmenuBorder = { fg = blend_border(theme.ui.bg_p1), bg = theme.ui.bg_p1 }, -- Added for completion menu border

					-- Diagnostic virtual text with blended backgrounds
					DiagnosticVirtualTextError = {
						fg = theme.diag.error,
						bg = require("kanagawa.lib.color")(theme.diag.error):blend(theme.ui.bg, 0.95):to_hex(),
					},
					DiagnosticVirtualTextWarn = {
						fg = theme.diag.warning,
						bg = require("kanagawa.lib.color")(theme.diag.warning):blend(theme.ui.bg, 0.95):to_hex(),
					},
					DiagnosticVirtualTextInfo = {
						fg = theme.diag.info,
						bg = require("kanagawa.lib.color")(theme.diag.info):blend(theme.ui.bg, 0.95):to_hex(),
					},
					DiagnosticVirtualTextHint = {
						fg = theme.diag.hint,
						bg = require("kanagawa.lib.color")(theme.diag.hint):blend(theme.ui.bg, 0.95):to_hex(),
					},

					-- LSP diagnostic floating windows
					DiagnosticFloatingError = { fg = theme.diag.error, bg = "none" },
					DiagnosticFloatingWarn = { fg = theme.diag.warning, bg = "none" },
					DiagnosticFloatingInfo = { fg = theme.diag.info, bg = "none" },
					DiagnosticFloatingHint = { fg = theme.diag.hint, bg = "none" },
					DiagnosticFloatingBorder = { fg = blend_border(theme.ui.bg_p1), bg = "none" }, -- Border for diagnostic floats

					-- Signature help window
					LspSignatureActiveParameter = { fg = theme.ui.special, bg = theme.ui.bg_p1, bold = true },
					LspSignatureBorder = { fg = blend_border(theme.ui.bg_p1), bg = "none" }, -- Border for signature help

					-- General floating windows
					NormalFloat = { bg = "none" },
					FloatBorder = { fg = blend_border(theme.ui.bg_p1), bg = "none" },
					FloatTitle = { fg = theme.ui.special, bg = "none", bold = true },

					-- Dimmed backgrounds for specific plugins
					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

					-- Disable cursor line highlighting
					CursorLine = { bg = "none" },
					CursorLineNr = { fg = theme.ui.fg, bg = "none" },

					-- Status line overrides
					StatusLine = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					StatusLineNC = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

					-- Netrw overrides
					Directory = { fg = theme.syn.identifier, bg = "none" },
					NetrwDir = { fg = theme.syn.identifier, bg = "none" },
					NetrwTreeBar = { fg = theme.ui.fg_dim, bg = "none" },
					NetrwExec = { fg = theme.syn.fun, bg = "none" },
					NetrwLink = { fg = theme.syn.string, bg = "none" },
					NetrwSymlink = { fg = theme.syn.string, bg = "none" },
				}
			end,
			theme = "dragon", -- Default theme
			background = {
				dark = "wave", -- Maps to wave theme for dark mode, also the option for "Dragon"
				light = "lotus", -- Maps to lotus theme for light mode
			},
		})

		-- Configure rounded borders for floating windows
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
		vim.lsp.handlers["textDocument/signatureHelp"] =
			vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
		vim.diagnostic.config({ float = { border = "rounded" } })

		-- Ensure Telescope uses rounded borders
		require("telescope").setup({
			defaults = {
				border = true,
				borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }, -- Rounded border characters
			},
		})
		-- Define custom lualine theme using Kanagawa colors
		local kanagawa_colors = require("kanagawa.colors").setup({ theme = "dragon" })
		local colors = kanagawa_colors.theme
		local lualine_theme = {
			normal = {
				a = { fg = colors.ui.fg, bg = colors.ui.bg_p2, gui = "bold" },
				b = { fg = colors.ui.fg_dim, bg = colors.ui.bg_m1 },
				c = { fg = colors.ui.fg_dim, bg = colors.ui.bg_m3 },
			},
			insert = {
				a = { fg = colors.syn.string, bg = colors.ui.bg_p1, gui = "bold" },
				b = { fg = colors.ui.fg_dim, bg = colors.ui.bg_m1 },
			},
			visual = {
				a = { fg = colors.syn.keyword, bg = colors.ui.bg_p1, gui = "bold" },
				b = { fg = colors.ui.fg_dim, bg = colors.ui.bg_m1 },
			},
			replace = {
				a = { fg = colors.diag.error, bg = colors.ui.bg_p1, gui = "bold" },
				b = { fg = colors.ui.fg_dim, bg = colors.ui.bg_m1 },
			},
			command = {
				a = { fg = colors.syn.fun, bg = colors.ui.bg_p1, gui = "bold" },
				b = { fg = colors.ui.fg_dim, bg = colors.ui.bg_m1 },
			},
			inactive = {
				a = { fg = colors.ui.fg_dim, bg = colors.ui.bg_m3 },
				b = { fg = colors.ui.fg_dim, bg = colors.ui.bg_m3 },
				c = { fg = colors.ui.fg_dim, bg = colors.ui.bg_m3 },
			},
		}

		-- Configure lualine with custom Kanagawa theme
		require("lualine").setup({
			options = {
				theme = lualine_theme, -- Use custom Kanagawa theme
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {},
				always_divide_middle = true,
				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
		})

		-- Kitty terminal theme
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "kanagawa",
			callback = function()
				if vim.o.background == "light" then
					vim.fn.system("kitty +kitten themes Kanagawa_light")
				elseif vim.o.background == "dark" then
					vim.fn.system("kitty +kitten themes Kanagawa_dragon")
				else
					vim.fn.system("kitty +kitten themes Kanagawa")
				end
			end,
		})

		-- Load the colorscheme
		require("kanagawa").load()
	end,
}
return M
