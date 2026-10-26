-- Disable flash.nvim (LazyVim default) so `s` stays the traditional
-- substitute key. The jump plugins tried here (leap, flash) conflicted
-- with the native workflow -- see commit f6973d1 for the history.
return {
  {
    "folke/flash.nvim",
    enabled = false,
  },
}
