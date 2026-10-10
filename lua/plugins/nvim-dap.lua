-- DAP plugin wiring.
--
-- The base debugging experience (standard <leader>d* keymaps, dap-ui,
-- virtual text, eval, launch.json support, auto open/close) comes from
-- LazyVim's `dap.core` extra. This file only adds:
--   1. a guard so mason-nvim-dap does not duplicate nvim-dap-go's Go configs
--   2. VSCode-style function-key aliases
--
-- Language launch configurations live in lua/config/dap/ and are loaded on
-- demand by lua/config/autocmds.lua.
return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = {
      -- debugpy for Python. delve comes from the Go extra via Mason.
      ensure_installed = { "python" },
      handlers = {
        -- nvim-dap-go owns the Go adapter and its configurations.
        -- mason-nvim-dap's setup_handlers runs the default handler for every
        -- *installed* source, so without this no-op the installed `delve`
        -- package would add a second, duplicate set of "Delve:" configs.
        delve = function() end,
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Run/Continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<F12>", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
    },
  },
}
