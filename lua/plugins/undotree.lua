-- Visualize and scrub the undo tree. `undofile` is already enabled by LazyVim.
return {
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" } },
  },
}
