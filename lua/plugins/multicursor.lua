-- VSCode-style multi-cursor.
--
-- NOTE: the key that *starts* multi-cursor from normal mode is "Find Under".
-- We keep it on <C-n> (the plugin default) so <C-d>/<C-u> stay as half-page
-- scroll. <C-Down>/<C-Up> add cursors below/above.
return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Select All"] = "<leader>A",
        ["Add Cursor Down"] = "<C-Down>",
        ["Add Cursor Up"] = "<C-Up>",
        ["Visual Cursors"] = false, -- keep it monochrome/clean
      }
    end,
  },
}
