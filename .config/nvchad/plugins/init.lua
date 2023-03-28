return {
  ["NvChad/ui"] = {
    override_options = {
      statusline = {
        overriden_modules = function()
          return {
            LSP_progress = function()
              return ""
            end,
          }
        end,
      },
    },
  },

  ["nvim-treesitter/nvim-treesitter"] = {
    override_options = {
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

  ["mrjones2014/nvim-ts-rainbow"] = {},

  ["chrisgrieser/nvim-spider"] = {},

  ["nvim-telescope/telescope.nvim"] = {
    module = "telescope",
    override_options = {
      extensions_list = { "themes", "terms", "notify" },
    },
  },

  ["williamboman/mason-lspconfig.nvim"] = {
    after = "mason.nvim",
    config = function()
      require("mason-lspconfig").setup({ automatic_installation = true })
    end,
  },

  ["jose-elias-alvarez/null-ls.nvim"] = {
    disable = false,
    event = "BufEnter",
    after = { "nvim-lspconfig", "mason-lspconfig.nvim" },
    config = function()
      require("custom.plugins.null-ls")
    end,
  },

  ["jayp0521/mason-null-ls.nvim"] = {
    after = { "mason.nvim", "null-ls.nvim" },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = nil,
        automatic_installation = true,
      })
    end,
  },

  ["neovim/nvim-lspconfig"] = {
    config = function()
      require("plugins.configs.lspconfig")
      require("custom.plugins.lspconfig")
    end,
  },

  ["folke/trouble.nvim"] = {
    commands = { "Trouble", "TroubleToggle" },
    config = function()
      require("trouble").setup()
    end,
  },

  ["folke/which-key.nvim"] = {
    disable = false,
  },

  ["akinsho/toggleterm.nvim"] = {
    tag = "*",
    config = function()
      require("custom.plugins.toggleterm").setup()
    end,
  },

  -- Load Comment.nvim eagerly to make mappings work
  ["numToStr/Comment.nvim"] = {
    event = "BufEnter",
  },

  ["github/copilot.vim"] = { after = "nvim-lspconfig" },

  ["vim-crystal/vim-crystal"] = { ft = { "crystal" } },

  ["andweeb/presence.nvim"] = {
    config = function()
      require("presence"):setup({
        main_image = "file",
      })
    end,
  },

  ["lervag/vimtex"] = { ft = { "tex", "latex", "plaintex" } },

  ["ionide/Ionide-vim"] = { ft = "fsharp" },

  ["iamcco/markdown-preview.nvim"] = { ft = "markdown" },

  ["tpope/vim-surround"] = {},

  ["goolord/alpha-nvim"] = {
    disable = false,
    override_options = require("custom.plugins.alpha"),
  },

  ["folke/drop.nvim"] = {
    event = "VimEnter",
    config = function()
      require("drop").setup({ theme = "snow" })
    end,
  },

  ["vypxl/persistence.nvim"] = {
    event = "BufReadPre",
    module = "persistence",
    config = function()
      require("persistence").setup({
        options = { "blank", "buffers", "curdir", "folds", "tabpages", "terminal", "winsize" },
        min_buffers = 2,
      })
    end,
  },

  ["folke/todo-comments.nvim"] = {
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup()
    end,
  },

  ["chrisgrieser/nvim-various-textobjs"] = {
    event = "BufEnter",
    config = function()
      require("various-textobjs").setup({ useDefaultKeymaps = true })
    end,
  },

  ["cvigilv/esqueleto.nvim"] = {
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

  ["glepnir/lspsaga.nvim"] = {
    after = "nvim-lspconfig",
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

  ["j-hui/fidget.nvim"] = {
    after = "nvim-lspconfig",
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
          ["null-ls"] = { ignore = true },
        },
      })
    end,
  },

  ["ckolkey/ts-node-action"] = {
    module = "ts-node-action",
    requires = "nvim-treesitter",
    config = function()
      require("ts-node-action").setup({})
    end,
  },

  ["ggandor/leap.nvim"] = {
    requires = "tpope/vim-repeat",
    keys = { "x", "X", "s", "S" },
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  ["rcarriga/nvim-notify"] = {
    module = "notify",
    config = function()
      require("notify").setup({
        stages = "fade",
      })
    end,
  },

  ["folke/noice.nvim"] = {
    requires = { "MunifTanjim/nui.nvim" },
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

  ["folke/twilight.nvim"] = {
    module = "twilight",
    config = function()
      require("twilight").setup({})
    end,
  },

  ["folke/zen-mode.nvim"] = {
    module = "zen-mode",
    requires = "folke/twilight.nvim",
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
