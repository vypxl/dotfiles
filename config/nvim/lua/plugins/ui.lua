Toggleterms = {}

return {
  -- colortheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 9001,
    opts = {
      flavour = "macchiato",
      show_end_of_buffer = true,
      integrations = {
        cmp = true,
        alpha = true,
        fidget = true,
        gitsigns = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = true,
        },
        leap = true,
        lsp_saga = true,
        markdown = true,
        noice = true,
        semantic_tokens = true,
        treesitter = true,
        treesitter_context = true,
        nvimtree = true,
        telescope = { enabled = true },
        lsp_trouble = true,
        which_key = true,
      },
    },
  },

  -- Display git info in the sign column
  { "lewis6991/gitsigns.nvim", event = "VeryLazy", opts = {} },

  -- Colorful braces and begin end blocks
  { "HiPhish/rainbow-delimiters.nvim", event = "BufEnter" },

  -- Tabs
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
    event = "VimEnter",
    keys = {
      { "<M-S-Left>", "<cmd> BufferLineCyclePrev<CR>", mode = "n", desc = "Switch to previous buffer" },
      { "<M-S-Right>", "<cmd> BufferLineCycleNext<CR>", mode = "n", desc = "Switch to next buffer" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
        separator_style = "thick",
        move_wraps_at_ends = true,
        always_show_bufferline = false,
      },
    },
    config = function(_, opts)
      -- this can't be done in opts, because catppuccin would not be loaded yet
      opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
      require("bufferline").setup(opts)
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      theme = "catppuccin",
      sections = {
        lualine_x = { "filetype", "filesize" },
      },
    },
  },

  -- Filetree
  {
    "nvim-tree/nvim-tree.lua",
    keys = { { "<C-b>", "<cmd> NvimTreeToggle<CR>", mode = "n", desc = "Toggle Filetree" } },
    opts = {},
  },

  -- Universal fuzzy finder / picker
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    keys = {
      { "<leader>f", "<cmd> Telescope find_files <CR>", mode = "n", desc = "Find file" },
      { "<leader>o", "<cmd> Telescope oldfiles <CR>", mode = "n", desc = "Recent files (oldfiles)" },
      { "<leader>w", "<cmd> Telescope live_grep <CR>", mode = "n", desc = "Find word (grep)" },
      { "<leader>b", "<cmd> Telescope buffers <CR>", mode = "n", desc = "Find buffer" },
    },
    opts = function()
      local actions = require "telescope.actions"
      return {
        defaults = {
          mappings = {
            i = {
              ["<ESC>"] = actions.close,
            },
          },
          layout_config = {
            horizontal = {
              prompt_position = "top",
            },
          },
          sorting_strategy = "ascending",
        },
      }
    end,
  },

  -- Display which key mappings are available by performing one partially
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = {},
  },

  -- Ui for listing diagnostics (and other things)
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    keys = {
      {
        "<leader>d",
        "<cmd>TroubleToggle workspace_diagnostics<CR>",
        mode = "n",
        desc = "Toggle trouble (Diagnostics)",
      },
      {
        "<leader>t",
        "<cmd>TroubleToggle todo<CR>",
        mode = "n",
        desc = "Toggle trouble (TODOs)",
      },
    },
    config = true,
  },

  -- Make TODO, FIXME and friends stand out more
  -- Note, this only detects comments where a colon (:) follows the TODO comment on purpose
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Floating terminals
  {
    "akinsho/toggleterm.nvim",
    version = "*",

    opts = {
      size = 20,
      open_mapping = [[<c-\>]],
      autochdir = true,
      direction = "float",
      shell = "fish",
      float_opts = {
        border = "curved",
      },
      winbar = { enabled = true },
      -- catppuccin integration
      notification = {
        window = {
          winblend = 0,
        },
      },
    },

    keys = {
      "<C-\\>",
      { "<leader>g", "<cmd> lua Toggleterms.lazygit:toggle() <CR>", mode = "n", desc = "Toggle Lazygit" },
      { "<leader>y", "<cmd> lua Toggleterms.lazygit_yadm:toggle() <CR>", mode = "n", desc = "Toggle Lazygit (yadm)" },
      {
        "<F5>",
        function()
          vim.api.nvim_command "wa"
          Toggleterms.run:toggle()
        end,
        mode = "n",
        desc = "Run",
      },
    },

    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal
      Toggleterms.lazygit = Terminal:new { cmd = "lazygit", hidden = true }
      Toggleterms.lazygit_yadm = Terminal:new { cmd = "lazygit -w ~ -g ~/.local/share/yadm/repo.git", hidden = true }
      Toggleterms.run = Terminal:new { cmd = "just; read -s -n 1", hidden = true }
    end,
  },

  -- Lsp Progress indicator
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
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
    },
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      bind = true,
      border = "rounded",
      hint_prefix = "  ",
    },
  },

  -- Shows the context (class / function / ..) the cursor is currently in at the top of the buffer
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufEnter",
  },
}
