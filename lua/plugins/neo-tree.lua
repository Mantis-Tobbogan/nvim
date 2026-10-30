return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      -- A little narrower than the LazyVim default; the glass sidebar should
      -- feel like a rail, not a second editor.
      width = 30,
      mappings = {
        -- your custom mappings if any
      },
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function()
          vim.opt_local.relativenumber = true
          vim.opt_local.number = true
        end,
      },
    },
  },
}
