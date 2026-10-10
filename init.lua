-- Cache compiled Lua modules for faster startup.
vim.loader.enable()

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
