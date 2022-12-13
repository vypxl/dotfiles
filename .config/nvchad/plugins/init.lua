return {
  ["williamboman/mason.nvim"] = {
    override_options = {
      ensure_installed = {
        "html-lsp",
        "clangd",
        "clang-format",
        "cmakelang",
        "rust-analyzer",
        "rustfmt",
        "gopls",
        "svelte-language-server",
        "tailwindcss-language-server",
        "pyright",
        "autopep8",
        "emmet-ls",
        "typescript-language-server",
        "crystalline",
        "haskell-language-server",
        "stylua",
        "prettier",
      }
    }
  },

  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
  },

  ["folke/which-key.nvim"] = {
    disable = false,
  },

  ["jose-elias-alvarez/null-ls.nvim"] = {
      after = "nvim-lspconfig",
      config = function()
         require "custom.plugins.null-ls"
      end,
 },

  -- surround, markdown-preview, presence.nvim, vimtex, ionide, 

  ["github/copilot.vim"] = { after = 'nvim-lspconfig' },

  ["vim-crystal/vim-crystal"] = { },

  ["andweeb/presence.nvim"] = { main_image = "file" },

  ["lervag/vimtex"] = { },

  ["ionide/Ionide-vim"] = { },

  ["iamcco/markdown-preview.nvim"] = { },

  ["tpope/vim-surround"] = { },

  --  ["hrsh7th/nvim-cmp"] = {
  --   override_options = function()
  --     local cmp = require "cmp"
  --
  --     return {
  --       mapping = {
  --         ["<C-d>"] = cmp.mapping.scroll_docs(-8),
  --       },
  --     }
  --   end,
  -- },

}
