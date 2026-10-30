-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Make mise-managed CLI tools (prettier, node, ...) visible to Neovim even when
-- it is launched outside an interactive shell (e.g. from a GUI/launcher).
local mise_shims = vim.fn.expand("~/.local/share/mise/shims")
if vim.fn.isdirectory(mise_shims) == 1 and not vim.env.PATH:find(mise_shims, 1, true) then
  vim.env.PATH = mise_shims .. ":" .. vim.env.PATH
end

-- Keep Neovim registers SEPARATE from the system clipboard.
-- LazyVim's default is `unnamedplus` (all yanks/deletes go to the system
-- clipboard); we explicitly override that back to the Vim default (empty).
-- `y`/`d`/`p` now only touch Neovim's own registers.
-- Use the explicit `+` register to cross the boundary:
--   `"+y` yank to system clipboard, `"+p` paste from it, or <C-S-v> to paste.
vim.opt.clipboard = ""

-- Font size h11 (~14.7px) matches the 14.5px buffer font used by VSCode
-- ("editor.fontSize") and Zed ("buffer_font_size") so the three editors show
-- code at the same scale.
vim.opt.guifont = "CaskaydiaCove Nerd Font:h11"
vim.opt.linespace = 3
vim.opt.relativenumber = true -- Force relative numbers everywhere
vim.opt.termguicolors = true
vim.opt.numberwidth = 1 -- Smallest width possible

-- More context around the cursor (closer to how Zed/VSCode feel).
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 12

-- Rounded borders on hover/signature/diagnostic/float windows (nvim 0.11+).
-- `pumborder` is the 0.12 equivalent for the native completion/mouse menu.
-- Keep both explicit: noice and blink set their own borders, and we want the
-- glass chrome to be consistent even if a plugin leaves border unset.
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"

-- No text blending. The frosted look comes from kitty's per-cell alpha
-- (`transparent_background_colors`), so floats stay crisp and readable.
vim.o.winblend = 0
vim.o.pumblend = 0

-- Mode cursor: block in normal/visual, vertical bar in insert,
-- underscore in replace. Explicit so nothing can quietly override it.
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,sm:block"

-- Theme, transparency and the :Theme command.
require("config.theme").setup()
