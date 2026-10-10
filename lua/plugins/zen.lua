-- Distraction-free writing/reading. Twilight dims everything but the current
-- block; Zen Mode hides the UI and centers the buffer.
return {
  {
    "folke/twilight.nvim",
    opts = {},
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = { { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
    opts = {
      plugins = {
        twilight = { enabled = true },
        gitsigns = { enabled = false },
      },
    },
  },
}
