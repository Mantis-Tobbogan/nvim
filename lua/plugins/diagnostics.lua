-- Readability-focused diagnostics.
--
--   * curly underlines (like VSCode/Zed) so problems are visible while reading
--   * clean Nerd Font signs
--   * no inline virtual text, to keep code uncluttered
return {
  -- Disable snacks notifier and dashboard
  {
    "folke/snacks.nvim",
    opts = {
      notifier = { enabled = false },
      dashboard = { enabled = false },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        -- No inline text for every diagnostic, but show the message for the
        -- current line only (IDE-style, unobtrusive).
        virtual_text = false,
        virtual_lines = { current_line = true },
        -- Underline problems (curly) instead of hiding them entirely
        underline = { severity = { min = vim.diagnostic.severity.HINT } },
        -- Clean Nerd Font icons in the gutter
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
        -- Don't update diagnostics while typing
        update_in_insert = false,
        -- Sort by severity
        severity_sort = true,
        -- Float window when you manually trigger diagnostics
        float = {
          enabled = true,
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
        -- Don't show float when jumping to diagnostics
        jump = { float = false },
      },
    },
  },
}
