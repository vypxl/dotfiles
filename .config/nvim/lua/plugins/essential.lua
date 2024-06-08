return {
  -- A utility library used by many plugins
  -- Not lazy loaded because I don't want to list it as a dependency everywhere
  { "nvim-lua/plenary.nvim", lazy = false },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    main = "ibl",
    opts = {
      debounce = 16,
      exclude = {
        filetypes = {
          "lspinfo",
          "lazy",
          "checkhealth",
          "help",
          "man",
          "terminal",
          "TelescopePrompt",
          "TelescopeResults",
          "mason",
          "alpha",
          "",
        },

        buftypes = { "terminal" },
      },
      scope = {
        include = { node_type = { ["*"] = { "*" } } },
      },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
      vim.api.nvim_set_hl(0, "@ibl.scope.underline.1", { bg = "#44475a" })

      -- Hide the first indent level
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
    end,
  },

  -- Highlighting and Indentation for almost all languages
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        -- ensure_installed = "all",
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
        auto_install = true,
        indent = {
          enable = true,
          disable = { "dart" }, -- https://github.com/UserNobody14/tree-sitter-dart/issues/60
        },
        highlight = {
          enable = true,
        },
      }
    end,
  },

  -- My mod of persistence.nvim
  -- Only used manually to reopen sessions I had in a directory
  {
    "vypxl/persistence.nvim",
    event = "BufReadPre", -- Needs to be loaded to save sessions automatically
    opts = {
      options = { "blank", "buffers", "curdir", "folds", "tabpages", "terminal", "winsize" },
      min_buffers = 2,
    },
  },

  -- File templates
  {
    "cvigilv/esqueleto.nvim",
    lazy = false, -- Does not work when opening a new file from cli otherwise
    opts = {
      directories = { "~/.config/file_templates" },
      patterns = {
        "python",
        "ruby",
        "LICENSE",
        "c",
        "cpp",
        "svelte",
      },
    },
  },
}
