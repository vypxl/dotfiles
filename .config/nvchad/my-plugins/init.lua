return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = "all",
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 2500,
        colors = {
          "#E8E9ED",
          "#009DDC",
          "#F26430",
          "#009B72",
          "#F2B134",
          "#DF57BC",
        },
      },
    },
  },

  { "mrjones2014/nvim-ts-rainbow", event = "VeryLazy" },

  { "chrisgrieser/nvim-spider" },

  { "nvim-telescope/telescope.nvim", opts = {
    extensions_list = { "themes", "terms", "notify" },
  } },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "williamboman/mason.nvim",
    config = function()
      require("mason-lspconfig").setup({ automatic_installation = true })
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = { "williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim" },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = nil,
        automatic_installation = true,
      })
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    config = function()
      require("trouble").setup()
    end,
  },

  { "folke/which-key.nvim", enabled = true },

  -- Load Comment.nvim eagerly to make mappings work
  { "numToStr/Comment.nvim", event = "VeryLazy" },

  {
    "github/copilot.vim",
    event = "VeryLazy",
    dependencies = "neovim/nvim-lspconfig",
  },

  { "vim-crystal/vim-crystal", ft = { "crystal" } },

  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    config = function()
      require("presence"):setup({
        main_image = "file",
      })
    end,
  },

  { "lervag/vimtex", ft = { "tex", "latex", "plaintex" } },

  { "ionide/Ionide-vim", ft = "fsharp" },

  { "iamcco/markdown-preview.nvim", ft = "markdown" },

  { "tpope/vim-surround", event = "VeryLazy" },

  {
    "folke/drop.nvim",
    event = "VeryLazy",
    config = function()
      require("drop").setup({ theme = "snow" })
    end,
  },

  {
    "vypxl/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        options = { "blank", "buffers", "curdir", "folds", "tabpages", "terminal", "winsize" },
        min_buffers = 2,
      })
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "VeryLazy",
    config = function()
      require("todo-comments").setup()
    end,
  },

  {
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    config = function()
      require("various-textobjs").setup({ useDefaultKeymaps = true })
    end,
  },

  {
    "cvigilv/esqueleto.nvim",
    lazy = false,
    config = function()
      require("esqueleto").setup({
        directories = { "~/.config/file_templates" },
        patterns = {
          "python",
          "ruby",
          "LICENSE",
          "c",
          "cpp",
        },
      })
    end,
  },

  {
    "glepnir/lspsaga.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      require("lspsaga").setup({
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
      })
    end,
  },

  {
    "j-hui/fidget.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      require("fidget").setup({
        text = {
          spinner = { "|", "/", "-", "\\" },
        },
        timer = {
          fidget_decay = 250,
          task_decay = 0,
        },
        sources = {
          { "null-ls", ignore = true },
        },
      })
    end,
  },

  {
    "ckolkey/ts-node-action",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    config = function()
      require("ts-node-action").setup({})
    end,
  },

  {
    "ggandor/leap.nvim",
    dependencies = "tpope/vim-repeat",
    keys = { "x", "X", "s", "S" },
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        stages = "fade",
      })
    end,
  },

  -- TODO:

  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    event = "VeryLazy",
    config = function()
      require("noice").setup({
        lsp = {
          progress = { enabled = false },
          signature = { enabled = false },
          hover = { enabled = false },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        notify = { enabled = false },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end,
  },

  {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup({})
    end,
  },

  {
    "folke/zen-mode.nvim",
    dependencies = "folke/twilight.nvim",
    config = function()
      require("zen-mode").setup({
        window = {
          options = {
            signcolumn = "no",
            number = false,
            relativenumber = false,
            cursorline = false,
            cursorcolumn = false,
            foldcolumn = "0",
            statuscolumn = "",
          },
        },
        plugins = {
          enabled = true,
          ruler = true,
          gitsigns = { enabled = true },
          kitty = {
            enabled = true,
            font = "+1.5",
          },
        },
      })
    end,
  },
}
