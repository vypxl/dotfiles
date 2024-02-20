return {
  -- Justfile
  {
    "NoahTheDuke/vim-just",
    ft = { "just" },
  },

  -- Typst
  {
    "kaarmu/typst.vim",
    ft = "typst",
  },

  -- Crystal
  { "vim-crystal/vim-crystal", ft = { "crystal" } },

  -- Scala
  {
    "scalameta/nvim-metals",
    dependencies = "nvim-lua/plenary.nvim",
    ft = { "scala", "sbt" },
    config = function()
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          require("metals").initialize_or_attach {}
        end,
        group = nvim_metals_group,
      })
    end,
  },

  -- Flutter
  {
    "akinsho/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = true,
  },

  -- LaTeX
  { "lervag/vimtex", ft = { "tex", "latex", "plaintex" } },

  -- F#
  { "ionide/Ionide-vim", ft = "fsharp" },

  -- Markdown
  { "iamcco/markdown-preview.nvim", ft = "markdown" },
}
