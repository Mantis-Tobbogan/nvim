-- Flash: jump to any visible text with `s`.
--
-- Replaces leap.nvim here: leap is currently incompatible with nvim
-- 0.12.x (its label/jump phase silently deadlocks -- tested at HEAD and
-- at the 2026-01 pin), while flash is actively maintained against 0.12.
--
-- Usage: `s` -> type 1-2 chars of any visible text -> type the shown
-- label if multiple matches. `S` = treesitter-aware select.
return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote Flash",
      },
    },
  },
}
