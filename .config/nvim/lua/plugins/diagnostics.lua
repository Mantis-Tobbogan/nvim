-- Configure LSP diagnostics with letter signs and no inline display
return {
  -- Disable snacks notifier and dashboard
  {
    "folke/snacks.nvim",
    opts = {
      notifier = { enabled = false },
      dashboard = { enabled = false },
    },
  },
  -- Configure diagnostics in nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        -- No inline text in the editor
        virtual_text = false,
        -- No underlining of problematic code
        underline = false,
        -- Show signs in the gutter
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
          },
        },
        -- Don't update diagnostics while typing
        update_in_insert = false,
        -- Sort by severity
        severity_sort = true,
        -- Float window options (when you manually trigger diagnostics)
        float = {
          enabled = false,
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
