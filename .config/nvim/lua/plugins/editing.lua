return {
  -- Commenting lines or regions
  {
    "numToStr/Comment.nvim",
    keys = {
      { "<leader>/", "<Plug>(comment_toggle_linewise_current)", mode = "n", desc = "Toggle Comment" },
      { "<leader>/", "<Plug>(comment_toggle_linewise_visual)", mode = "v", desc = "Toggle Comment" },
    },
    opts = {
      mappings = { basic = false, extra = false },
    },
  },

  -- Easy incremental selection
  {
    "sustech-data/wildfire.nvim",
    keys = { "\\" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      keymaps = {
        init_selection = "\\",
        node_incremental = "\\",
        node_decremental = "<BS>",
      },
    },
  },

  -- Surrounding text objects or selections with quotes, delimiters, etc.
  {
    "kylechui/nvim-surround",
    event = "VeryLazy", -- too many mappings to list them
    config = true,
  },

  -- Collection of useful stuff around lsp (renamer, code actions, doc hover, ..)
  -- Mappings are in mappings.lua for them to be in the same place as other lsp mappings
  {
    "glepnir/lspsaga.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
      border_style = "rounded",
      preview_lines_above = 3,
      rename_action_quit = "<ESC>",
      definition_action_keys = {
        edit = "<CR>",
        vsplit = "s",
        split = "i",
        tabe = "t",
        quit = "q",
      },
      symbol_in_winbar = { enable = true },
      lightbulb = { virtual_text = false },
    },
  },

  -- One mapping for a bunch of useful actions, like
  -- * toggling identifier casing
  -- * expanding / contracting tables and lists
  -- * toggling true / false
  -- * toggling comparison operators < / >
  {
    "ckolkey/ts-node-action",
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = {
      {
        "<leader>a",
        "<cmd>lua require('ts-node-action').node_action()<CR>",
        mode = "n",
        desc = "Treesitter node action",
      },
    },
    config = true,
  },

  -- Instant navigation anywhere via s/S
  {
    "ggandor/leap.nvim",
    dependencies = "tpope/vim-repeat",
    keys = { "s", "S" },
    config = function()
      require("leap").create_default_mappings()
    end,
  },

  -- Alternative default motions
  -- Makes 'w', 'b', .. more useful
  {
    "chrisgrieser/nvim-spider",
    keys = { "w", "e", "b" },
    config = function()
      local spider = {
        ["w"] = "<cmd>lua require('spider').motion('w')<CR>",
        ["e"] = "<cmd>lua require('spider').motion('e')<CR>",
        ["b"] = "<cmd>lua require('spider').motion('b')<CR>",
      }
      local map = vim.keymap.set

      map({ "n", "x" }, "w", spider.w)
      map({ "o" }, "w", spider.e) -- not w, because we don't want to delete the start of the next word
      map({ "n", "x" }, "e", spider.e)
      map({ "o" }, "e", "<cmd>normal!w<CR>") -- use e in op mode to get usual w behaviour
      map({ "n", "x", "o" }, "b", spider.b)
    end,
  },
}
