-- Smarter word motions: w/e/b stop at camelCase and snake_case boundaries
-- instead of treating the whole identifier as one word.
return {
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "x", "o" }, desc = "Next word" },
      { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "x", "o" }, desc = "End of word" },
      { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "x", "o" }, desc = "Prev word" },
      { "ge", "<cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "x", "o" }, desc = "Prev end of word" },
    },
  },
}
