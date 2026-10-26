-- Markdown: keep raw text by default.
--
-- The `lang.markdown` extra enables render-markdown.nvim, which live-renders
-- headings/tables/etc. inside the buffer. We disable that initial rendering so
-- Markdown looks like plain text; `<leader>um` toggles the rendered view if you
-- ever want it.
--
-- (Browser preview is separate and already provided by the extra: `<leader>cp`.)
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = { enabled = false },
  },
  -- Kill markdownlint (MD013 line-length and friends) — prose is written
  -- freely here; the 80-column rules are noise.
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = nil
    end,
  },
}
