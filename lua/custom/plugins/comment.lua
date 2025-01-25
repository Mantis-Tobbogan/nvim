local M = {
  'numToStr/Comment.nvim',
  opts = {
    -- add any options here
  },
  lazy = false,
}
function M.config()
  local main = require 'Comment'
  main.setup()
end

return M
