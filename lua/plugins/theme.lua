return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("kanagawa").setup({
        theme = "dragon",
        background = { dark = "dragon", light = "lotus" },
        dimInactive = true,
        globalStatus = true,
        terminalColors = true,
        transparent = true,
        colors = {
          theme = { all = { ui = { bg_gutter = "none" } } },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { fg = theme.ui.float.fg_border, bg = "none" },

            TelescopeBorder = { fg = theme.ui.float.fg_border, bg = "none" },
            TelescopeSelection = { bg = theme.ui.bg_p2 },

            NeoTreeNormal = { bg = theme.ui.bg_m1 },
            NeoTreeWinSeparator = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },

            WhichKey = { fg = theme.syn.keyword },
            WhichKeyGroup = { fg = theme.syn.fun },

            NoiceCmdlinePopupBorder = { fg = theme.syn.keyword },
          }
        end,
      })
      vim.cmd("colorscheme kanagawa-dragon")
    end,
  },

  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "kanagawa" } } },
}

-----------------------------------------------------------------------------------------------------
--[[ return {

  ---------------------------------------------------------------------------
  -- 1. Main Kanagawa Colorscheme
  ---------------------------------------------------------------------------
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("kanagawa").setup({
        theme = "dragon", -- dragon = muted, low-contrast; wave = classic
        background = {
          dark = "dragon",
          light = "lotus",
        },
        transparent = false,
        dimInactive = true,
        globalStatus = true,
        terminalColors = true,

        colors = {
          theme = {
            all = { ui = { bg_gutter = "none" } },
          },
        },

        overrides = function(colors)
          local theme = colors.theme
          return {

            -------------------------------------------------------------------
            -- Core UI polish
            -------------------------------------------------------------------
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none", fg = theme.ui.float.fg_border },
            Pmenu = { bg = theme.ui.bg_p1 },
            PmenuSel = { bg = theme.ui.bg_p2, fg = theme.ui.fg },

            -------------------------------------------------------------------
            -- Telescope
            -------------------------------------------------------------------
            TelescopeBorder = { fg = theme.ui.float.fg_border, bg = "none" },
            TelescopePromptBorder = { fg = theme.ui.float.fg_border, bg = "none" },
            TelescopePromptTitle = { fg = theme.syn.keyword },
            TelescopeResultsTitle = { fg = theme.syn.keyword },
            TelescopeSelection = { bg = theme.ui.bg_p2, bold = true },

            -------------------------------------------------------------------
            -- Neo-tree
            -------------------------------------------------------------------
            NeoTreeNormal = { bg = theme.ui.bg_m1 },
            NeoTreeNormalNC = { bg = theme.ui.bg_m1 },
            NeoTreeWinSeparator = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },

            NeoTreeDirectoryName = { fg = theme.syn.fun },
            NeoTreeDirectoryIcon = { fg = theme.syn.fun },
            NeoTreeIndentMarker = { fg = theme.ui.fg_dim },
            NeoTreeExpander = { fg = theme.syn.keyword },

            NeoTreeGitModified = { fg = theme.vcs.modified },
            NeoTreeGitAdded = { fg = theme.vcs.added },
            NeoTreeGitDeleted = { fg = theme.vcs.removed },

            -------------------------------------------------------------------
            -- Noice / cmdline
            -------------------------------------------------------------------
            NoiceCmdlinePopupBorder = { fg = theme.syn.keyword },
            NoiceCmdlineIcon = { fg = theme.syn.keyword },
            NoicePopupBorder = { fg = theme.ui.float.fg_border },

            -------------------------------------------------------------------
            -- Which-key
            -------------------------------------------------------------------
            WhichKey = { fg = theme.syn.keyword },
            WhichKeyGroup = { fg = theme.syn.fun },
            WhichKeyDesc = { fg = theme.syn.operator },

            -------------------------------------------------------------------
            -- Lazy UI
            -------------------------------------------------------------------
            LazyNormal = { bg = theme.ui.bg_m1, fg = theme.ui.fg },
            LazyProgressDone = { fg = theme.syn.keyword },
            LazyProgressTodo = { fg = theme.ui.fg_dim },

            -------------------------------------------------------------------
            -- Indentscope (mini.indentscope)
            -------------------------------------------------------------------
            MiniIndentscopeSymbol = { fg = theme.syn.keyword },
            MiniIndentscopePrefix = { fg = theme.syn.keyword },

            -------------------------------------------------------------------
            -- Treesitter tweaks
            -------------------------------------------------------------------
            ["@variable"] = { fg = theme.syn.variable },
            ["@variable.builtin"] = { fg = theme.syn.special },
            ["@property"] = { fg = theme.syn.field },
          }
        end,
      })

      vim.cmd("colorscheme kanagawa-dragon")
    end,
  },

  ---------------------------------------------------------------------------
  -- 2. Lualine – **must** be explicit to avoid LazyVim overrides
  ---------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.theme = "kanagawa"
    end,
  },

  ---------------------------------------------------------------------------
  -- 3. Neo-tree – ensure it inherits colors cleanly
  ---------------------------------------------------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        width = 30,
        mappings = {},
      },
      filesystem = {
        filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false },
      },
    },
  },

  ---------------------------------------------------------------------------
  -- 4. Snacks UI (LazyVim popups, notifications, etc.)
  ---------------------------------------------------------------------------
  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        style = "minimal",
      },
      dashboard = {
        preset = "kanagawa",
      },
    },
  },

  ---------------------------------------------------------------------------
  -- 5. Telescope – additional polish
  ---------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        borderchars = {
          prompt = { " ", " ", " ", " ", " ", " ", " ", " " },
          results = { " ", " ", " ", " ", " ", " ", " ", " " },
          preview = { " ", " ", " ", " ", " ", " ", " ", " " },
        },
      },
    },
  },
} ]]
