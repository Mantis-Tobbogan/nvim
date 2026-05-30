-- File: ~/.config/nvim/lua/config/dap/go.lua

local dap = require("dap")

-- ========================================
-- Go Debugger Configuration (Delve)
-- ========================================
dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "delve",
    name = "Debug (with arguments)",
    request = "launch",
    program = "${file}",
    args = function()
      local args_string = vim.fn.input("Arguments: ")
      return vim.split(args_string, " +")
    end,
  },
  {
    type = "delve",
    name = "Debug Package",
    request = "launch",
    program = "${fileDirname}",
  },
  {
    type = "delve",
    name = "Debug test",
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  {
    type = "delve",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
  {
    type = "delve",
    name = "Attach to process",
    mode = "local",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
  {
    type = "delve",
    name = "Debug with build flags",
    request = "launch",
    program = "${file}",
    buildFlags = function()
      local flags = vim.fn.input("Build flags: ")
      return flags
    end,
  },
}
