-- debug.lua
--
-- Neovim DAP configuration with Python (debugpy), Go, etc.
-- Supports project-local .vscode/launch.json and virtualenv detection.

--[[ return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		"mfussenegger/nvim-dap-python",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- 🔹 Detect local venv or fallback to system python
		local function get_python_path()
			local cwd = vim.fn.getcwd()
			if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
				return cwd .. "/venv/bin/python"
			elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
				return cwd .. "/.venv/bin/python"
			else
				return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
			end
		end

		-- 🔹 Setup python adapter (debugpy)
		require("dap-python").setup(get_python_path())

		-- Alias adapter: allow "debugpy" in launch.json
		dap.adapters.debugpy = dap.adapters.python

		-- 🔹 Load VSCode-style launch.json if present
		local ok, _ = pcall(function()
			require("dap.ext.vscode").load_launchjs(nil, {
				debugpy = { "python" }, -- map VSCode "debugpy" configs to python adapter
				python = { "python" }, -- (in case some configs still say "python")
				go = { "go" },
			})
		end)
		if not ok then
			vim.notify("No launch.json found for dap", vim.log.levels.DEBUG)
		end

		-- 🔹 Mason DAP setup
		require("mason-nvim-dap").setup({
			automatic_installation = false,
			automatic_setup = true,
			handlers = {},
			ensure_installed = {
				"debugpy",
				"delve",
			},
		})

		-- 🔹 DAP UI setup
		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		-- Auto open/close dap-ui
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- 🔹 Keymaps
		vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP Continue" })
		vim.keymap.set("n", "<F6>", dap.step_over, { desc = "DAP Step Over" })
		vim.keymap.set("n", "<F7>", dap.step_into, { desc = "DAP Step Into" })
		vim.keymap.set("n", "<F8>", dap.step_out, { desc = "DAP Step Out" })
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "DAP Conditional Breakpoint" })
		vim.keymap.set("n", "<F3>", dapui.toggle, { desc = "DAP UI Toggle" })
	end,
} ]]
return {}
