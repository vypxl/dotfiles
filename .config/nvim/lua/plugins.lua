return require('packer').startup(function(use)
  -- Let packer self-manage
  use "wbthomason/packer.nvim"

  use {
    -- deps
    'nvim-lua/plenary.nvim',
    'kyazdani42/nvim-web-devicons',

    -- ui
    'dracula/vim',
    'norcalli/nvim-colorizer.lua',
    'lukas-reineke/indent-blankline.nvim',
    'akinsho/bufferline.nvim',
    'famiu/feline.nvim',
    'kyazdani42/nvim-tree.lua',
    'nvim-telescope/telescope.nvim',

    -- functionality
    'max397574/better-escape.nvim',
    'lewis6991/gitsigns.nvim',
    'windwp/nvim-autopairs',
    'numToStr/Comment.nvim',
    'tpope/vim-surround',
    'iamcco/markdown-preview.nvim',
    'honza/vim-snippets',

    -- language plugins
    'lervag/vimtex',
    'benknoble/vim-mips',
    'vim-crystal/vim-crystal',

    -- smartness
    'nvim-treesitter/nvim-treesitter',
    'neovim/nvim-lspconfig',
    'cohama/lexima.vim',
    'dense-analysis/ale',

  }
  use { 'neoclide/coc.nvim', branch = 'release' }

  -- Setup icons
  require('nvim-web-devicons').setup {
    default = true
  }

  -- Indent guides
  require('indent_blankline').setup {}

  -- Better escape
  require("better_escape").setup {
    mapping = {"jk", "kj"},
    timeout = 150,
    clear_empty_lines = true,
  }

  -- Tree
  vim.g.nvim_tree_highlight_opened_files = 1
  vim.g.nvim_tree_add_trailing = 1
  require('nvim-tree').setup {
    diagnostics = { enable = true, },
    disable_window_picker = true,
  }

  -- Buffer line
  require("bufferline").setup {
    diagnostics = 'nvim_lsp',
    offsets = { { filetype = "NvimTree", text = function() return vim.fn.getcwd() end, highlight = "Directory", text_align = "center" } }
  }

  -- Status line
  vim.opt.termguicolors = true
  require('feline').setup({
    preset = 'round'
  })

  -- Gitsigns
  require('gitsigns').setup()

  -- Autopairs
  require('nvim-autopairs').setup {}

  -- Comment
  require('Comment').setup()

  -- TreeSitter
  require('nvim-treesitter.configs').setup {
    ensure_installed = "maintained",
    highlight = { enable = true },
  }

  -- Ale
  vim.g.ale_disable_lsp = 1

  -- Autocomplete
  vim.g.coc_global_extensions = {
    'coc-lua',
    'coc-html',
    'coc-tsserver',
    'coc-css',
    'coc-json',
    'coc-clangd',
    'coc-cmake',
    'coc-discord',
    'coc-dot-complete',
    'coc-elixir',
    'coc-emmet',
    'coc-eslint',
    'coc-fzf-preview',
    'coc-git',
    'coc-go',
    'coc-glslx',
    'coc-graphql',
    'coc-java',
    'coc-julia',
    'coc-metals',
    'coc-omnisharp',
    'coc-prettier',
    'coc-pyright',
    'coc-rust-analyzer',
    'coc-sh',
    'coc-snippets',
    'coc-solargraph',
    'coc-svelte',
    'coc-vetur',
    'coc-vimtex',
    'coc-yaml'
  }

  -- Set colorscheme
  vim.g.dracula_transparent_bg = false
  vim.cmd[[colorscheme dracula]]

end)
