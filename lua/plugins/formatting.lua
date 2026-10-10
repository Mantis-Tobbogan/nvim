-- Formatters are installed and managed by `mise`, not Mason.
--
-- LazyVim's "formatting.prettier" extra (enabled in lazyvim.json):
--   1. registers `prettier` in conform.nvim for json/js/ts/css/html/yaml/...
--   2. asks Mason to install its own copy of prettier
--
-- We keep (1) but drop (2) so the single source of truth is the mise binary on
-- PATH. Install/update it with:  mise use -g prettier
--
-- To move any other formatter/linter to mise, add it to the filter below (and
-- install it with `mise use -g <tool>`).
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(pkg)
        return pkg ~= "prettier"
      end, opts.ensure_installed or {})
    end,
  },

  -- ---------------------------------------------------------------------
  -- Wire formatters that you installed with mise into conform.nvim.
  -- LazyVim merges this `opts` on top of its own config (and its extras').
  -- ---------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- filetype = { "formatter-command" }
        toml = { "taplo" },
      },
    },
  },
}
