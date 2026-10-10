-- Git quality-of-life. Gitsigns already ships with LazyVim; just turn on
-- inline blame (like VSCode's gutter blame, but at end of line).
return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text_pos = "eol",
        delay = 300,
      },
      current_line_blame_formatter = "  <author>, <author_time:%R> • <summary>",
    },
  },
}
