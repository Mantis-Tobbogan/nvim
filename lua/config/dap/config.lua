-- File: ~/.config/nvim/lua/config/dap/config.lua

local dap = require("dap")
local dapui = require("dapui")
local mason_dap = require("mason-nvim-dap")
local dap_virtual_text = require("nvim-dap-virtual-text")

-- ========================================
-- DAP Virtual Text Setup
-- ========================================
dap_virtual_text.setup({
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  filter_references_pattern = "<module",
  virt_text_pos = "eol",
  all_frames = false,
  virt_lines = false,
  virt_text_win_col = nil,
})

-- ========================================
-- Mason DAP Setup
-- ========================================
mason_dap.setup({
  ensure_installed = { "python", "delve" },
  automatic_installation = true,
  handlers = {
    function(config)
      require("mason-nvim-dap").default_setup(config)
    end,
  },
})

-- ========================================
-- DAP UI Setup
-- ========================================
dapui.setup({
  controls = {
    element = "repl",
    enabled = true,
    icons = {
      disconnect = "",
      pause = "",
      play = "",
      run_last = "",
      step_back = "",
      step_into = "",
      step_out = "",
      step_over = "",
      terminate = "",
    },
  },
  element_mappings = {},
  expand_lines = true,
  floating = {
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  force_buffers = true,
  icons = {
    collapsed = "",
    current_frame = "",
    expanded = "",
  },
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      position = "left",
      size = 40,
    },
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      position = "bottom",
      size = 10,
    },
  },
  mappings = {
    edit = "e",
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    repl = "r",
    toggle = "t",
  },
  render = {
    indent = 1,
    max_value_lines = 100,
  },
})

-- ========================================
-- Breakpoint Icons
-- ========================================
vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "⭕", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapLogPoint", linehl = "", numhl = "" })

-- ========================================
-- Auto-open/close DAP UI
-- ========================================
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- ========================================
-- Keymaps
-- ========================================
vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Continue" })
vim.keymap.set("n", "<leader>dC", function()
  vim.ui.input({ prompt = "Condition: " }, function(condition)
    if condition then
      dap.set_breakpoint(condition)
    end
  end)
end, { desc = "Debug: Conditional Breakpoint" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>db", dap.step_back, { desc = "Debug: Step Back" })
vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Debug: Restart" })
vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run Last" })
vim.keymap.set("n", "<leader>dq", function()
  dap.terminate()
  dapui.close()
end, { desc = "Debug: Terminate" })
vim.keymap.set("n", "<leader>dR", dap.repl.open, { desc = "Debug: Open REPL" })
vim.keymap.set("n", "<leader>dh", require("dap.ui.widgets").hover, { desc = "Debug: Hover" })
vim.keymap.set("n", "<leader>dp", require("dap.ui.widgets").preview, { desc = "Debug: Preview" })
vim.keymap.set("n", "<leader>df", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end, { desc = "Debug: Frames" })
vim.keymap.set("n", "<leader>ds", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end, { desc = "Debug: Scopes" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
vim.keymap.set("n", "<leader>dB", function()
  dap.list_breakpoints()
  vim.cmd("copen")
end, { desc = "Debug: List Breakpoints" })
vim.keymap.set("n", "<leader>dX", dap.clear_breakpoints, { desc = "Debug: Clear All Breakpoints" })
