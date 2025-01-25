local M = {
  'jose-elias-alvarez/null-ls.nvim',
  event = 'BufReadPre',
}

function M.config()
  local null_ls = require 'null-ls'
  local b = null_ls.builtins
  local ruff_args = {
    '--select',
    'B,C,E,F,W,T4,B9,I001',
    '--ignore',
    'E203,E266,E501,W503,F403,F401,E712,C901,E402,F405',
    '--max-line-length',
    '120',
    '--per-file-ignores',
    '__init__.py:E402 **/{tests,docs,tools}/*:E402',
    '--isort',
    '--isort-known-third-party',
    '',
    '--isort-known-first-party',
    '',
    '--isort-sections',
    'FUTURE,STDLIB,THIRDPARTY,FIRSTPARTY,LOCALFOLDER',
  }

  local sources = {
    --python
    --b.formatting.black,
    b.formatting.ruff,
    b.diagnostics.ruff.with { extra_args = ruff_args },

    --lua
    b.formatting.stylua,

    --frontend
    b.formatting.prettier.with {
      filetypes = { 'html', 'json', 'yaml', 'markdown' },
    },
    b.diagnostics.deno_lint,
    b.diagnostics.djlint,

    --random
    b.diagnostics.eslint,
    b.completion.spell,
    b.formatting.remark,

    --luasnip
    b.completion.luasnip,
    b.completion.tags,

    --C
    --b.formatting.clang_format,
    --b.formatting.cpptools,
    b.formatting.cmake_format,
    --b.formatting.geresmi,

    --git
    b.code_actions.gitsigns,
  }

  null_ls.setup {
    debug = true,
    sources = sources,
  }
end

return M
