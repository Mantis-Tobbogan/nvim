-- Window commands: <leader>w* — identical set to the Zed keymap so muscle
-- memory transfers between editors.
--
--   ww other · wd delete · wm maximize
--   w- below · w| right
--   wh/wj/wk/wl focus left/down/up/right

local map = vim.keymap.set
local opts = { desc = "Window" }

map("n", "<leader>ww", "<C-w>p", opts)
map("n", "<leader>wd", "<C-w>c", opts)
map("n", "<leader>wm", "<C-w>|<C-w>_")

map("n", "<leader>w-", "<C-w>s", opts)
map("n", "<leader>w|", "<C-w>v", opts)

map("n", "<leader>wh", "<C-w>h", opts)
map("n", "<leader>wj", "<C-w>j", opts)
map("n", "<leader>wk", "<C-w>k", opts)
map("n", "<leader>wl", "<C-w>l", opts)

return {}
