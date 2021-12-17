vim.api.nvim_exec([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]], false)

return require('packer').startup(function(use)
  -- Let packer self-manage
  use "wbthomason/packer.nvim"

  use {
    -- deps
    'nvim-lua/plenary.nvim',
    'kyazdani42/nvim-web-devicons',

    -- ui
    'Mofiqul/dracula.nvim',
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

    -- smartness
    'nvim-treesitter/nvim-treesitter',
    'neovim/nvim-lspconfig',
  }

  use { 'ms-jpq/coq_nvim', { branch = 'coq'} }
  use { 'ms-jpq/coq.artifacts', { branch = 'artifacts' } }
  use { 'ms-jpq/coq.thirdparty', { branch = '3p' } }

  -- Setup icons
  require('nvim-web-devicons').setup {
    default = true
  }

  -- Set colorscheme
  vim.g.dracula_transparent_bg = false
  vim.cmd[[colorscheme dracula]]

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
  vim.g.nvim_tree_disable_window_picker = 1
  require('nvim-tree').setup {
    diagnostics = { enable = true, },
    auto_close = true,
  }

  -- Buffer line
  require("bufferline").setup {
    diagnostics = 'nvim_lsp',
    offsets = { { filetype = "NvimTree", text = function() return vim.fn.getcwd() end, highlight = "Directory", text_align = "center" } }
  }

  -- Status line
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
    ensure_installed = "maintained"
  }

  -- Autocomplete
  vim.g.coq_settings = {
    auto_start = 'shut-up',
    display = { pum = { fast_close = false } },
    keymap = {
      jump_to_mark = '',
      bigger_preview = '',
    }
  }
  local lsp = require("lspconfig")
  local coq = require("coq")
  require('lspsetup')(lsp, coq)

end)

