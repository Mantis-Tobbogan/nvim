return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		signs = true, -- Show icons in the signs column
		sign_priority = 8, -- Sign priority
		keywords = {
			TODO = { icon = " ", color = "todo", alt = { "todo" } },
			WARN = { icon = " ", color = "warn", alt = { "WARNING", "XXX" } },
			OPTIM = { icon = " ", color = "optim", alt = { "OPTIMIZE", "PERFORMANCE" } },
			PERF = { icon = "⏲ ", color = "perf" },
			FIX = { icon = " ", color = "fix", alt = { "FIXME", "FIXIT", "ISSUE" } },
			HACK = { icon = " ", color = "hack", alt = { "WORKAROUND" } },
			BUG = { icon = " ", color = "bug" },
			NOTE = { icon = "", color = "note", alt = { "INFO" } },
		},
		gui_style = {
			fg = "NONE", -- Foreground style (use default unless overridden)
			bg = "BOLD", -- Background style (bold for emphasis)
		},
		colors = {
			todo = { "DiagnosticInfo", "#1E90FF" }, -- DodgerBlue
			warn = { "DiagnosticWarn", "#FF8C00" }, -- DarkOrange
			optim = { "DiagnosticHint", "#2E8B57" }, -- SeaGreen
			perf = { "Identifier", "#6A5ACD" }, -- SlateBlue
			fix = { "DiagnosticError", "#C71585" }, -- MediumVioletRed
			hack = { "WarningMsg", "#FF6347" }, -- Tomato
			bug = { "DiagnosticError", "#DC143C" }, -- Crimson
			note = { "DiagnosticInfo", "#4682B4" }, -- SteelBlue
		},
		highlight = {
			multiline = true, -- Enable multiline comments
			pattern = [[.*<(KEYWORDS)\s*:]], -- Match keywords followed by colon
			comments_only = true, -- Highlight only in comments (using treesitter)
			max_line_len = 400, -- Ignore long lines
			exclude = {}, -- Filetypes to exclude
		},
		search = {
			command = "rg",
			args = {
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
			},
			pattern = [[\b(KEYWORDS):]], -- Ripgrep regex for searching
		},
	},
	config = function(_, opts)
		require("todo-comments").setup(opts)
		-- Custom highlight for HACK to simulate strikethrough (optional)
		vim.api.nvim_set_hl(0, "TodoHack", { fg = "#FF6347", underline = true, italic = true })
	end,
}
