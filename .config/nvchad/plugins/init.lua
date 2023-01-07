return {
  ["nvim-treesitter/nvim-treesitter"] = {
    override_options = {
      ensure_installed = "all",
    },
  },

  ["williamboman/mason.nvim"] = {
    override_options = {
      ensure_installed = {
        "clang-format",
        "rustfmt",
        "autopep8",
        "stylua",
        "prettier",
      },
    },
  },

  ["williamboman/mason-lspconfig.nvim"] = {
    after = "mason.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "awk_ls",
          "bashls",
          "clangd",
          "cmake",
          "crystalline",
          "elixirls",
          "emmet_ls",
          "gopls",
          "haxe_language_server",
          "hls",
          "html",
          "jsonls",
          "ocamllsp",
          "omnisharp",
          "pyright",
          "remark_ls",
          "rnix",
          "rust_analyzer",
          "solargraph",
          "svelte",
          "tailwindcss",
          "taplo",
          "tsserver",
          "volar",
          "yamlls",
          "zls",
        },
        automatic_installation = true,
      })
    end,
  },

  ["jose-elias-alvarez/null-ls.nvim"] = {
    disable = false,
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

  -- Load Comment.nvim eagerly to make mappings work
  ["numToStr/Comment.nvim"] = {
    event = "BufRead",
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
  },

  ["folke/drop.nvim"] = {
    event = "VimEnter",
    config = function()
      require("drop").setup({ theme = "snow" })
    end,
  }
}
