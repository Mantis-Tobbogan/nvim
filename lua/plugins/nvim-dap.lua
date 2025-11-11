-- File: ~/.config/nvim/lua/plugins/nvim-dap.lua
local M = {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "jay-babu/mason-nvim-dap.nvim",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    -- Load core DAP configuration (UI, keymaps, etc.)
    require("config.dap.config")

    -- Load language-specific configurations
    require("config.dap.python")
    require("config.dap.go")
  end,
}

-- return M
return {}
