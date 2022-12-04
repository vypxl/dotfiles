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
    'L3MON4D3/LuaSnip',
    'andweeb/presence.nvim',

    -- Autocomplete
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-calc',
    'saadparwaiz1/cmp_luasnip',
    'onsails/lspkind.nvim',
    'hrsh7th/nvim-cmp',

    -- language plugins
    'lervag/vimtex',
    'benknoble/vim-mips',
    'vim-crystal/vim-crystal',
    'ionide/Ionide-vim',

    -- smartness
    'nvim-treesitter/nvim-treesitter',
    'neovim/nvim-lspconfig',
    'cohama/lexima.vim',
    'dense-analysis/ale',
    'github/copilot.vim'

  }

  -- Load snippets from vim-snippets
  require("luasnip.loaders.from_snipmate").lazy_load()

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
  require('nvim-tree').setup {
    diagnostics = { enable = true, },
    renderer = {
      highlight_opened_files = "icon",
      highlight_git = true,
      add_trailing = true,
    },
  }

  -- Buffer line
  require("bufferline").setup {
    options = {
      diagnostics = 'nvim_lsp',
      offsets = { { filetype = "NvimTree", text = function() return vim.fn.getcwd() end, highlight = "Directory", text_align = "center" } },
    },
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
    ensure_installed = "all",
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = { enable = true }
  }

  -- Ale
  vim.g.ale_disable_lsp = 1

  -- TEMPORARY fix for ionide
  vim.g['fsharp#fsautocomplete_command'] = { 'fsautocomplete', '--adaptive-lsp-server-enabled' }

  -- Autocomplete
  local cmp = require('cmp')
  local lspkind = require('lspkind')
  local luasnip = require("luasnip")

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end
  local select_opts = {behavior = cmp.SelectBehavior.Select}

  cmp.setup {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
       ["<Tab>"] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif cmp.visible() then
          local entry = cmp.get_selected_entry()
          if entry ~= nil then
            cmp.confirm()
          else
            cmp.select_next_item()
          end
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<CR>"] = cmp.mapping(function(fallback)
        if cmp.visible() and cmp.get_selected_entry ~= nil then
          cmp.confirm()
        else
          fallback()
        end

      end, { "i", "s" }),
      ["<C-c>"] = cmp.mapping.abort(),
      ['<Up>'] = cmp.mapping.select_prev_item(),
      ['<Down>'] = cmp.mapping.select_next_item(),
    },
    enabled = function()
      -- disable completion in comments
      local context = require 'cmp.config.context'
      -- disable on empty lines
      local col = vim.fn.col('.') - 1
      if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return false
      -- keep command mode completion enabled when cursor is in a comment
      elseif vim.api.nvim_get_mode().mode == 'c' then
        return true
      else
        return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
      end
    end,
    window = {
      completion = {
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        col_offset = -3,
        side_padding = 0,
      },
      documentation = cmp.config.window.bordered(),
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        if vim.tbl_contains({ 'path' }, entry.source.name) then
          local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
          if icon then
            vim_item.kind = icon
            vim_item.kind_hl_group = hl_group
            return vim_item
          end
        end
        local kind = lspkind.cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. strings[1] .. " "
        kind.menu = "    (" .. strings[2] .. ")"

        return kind
      end
    },
    view = {
      entries = {name = 'custom', selection_order = 'near_cursor' }
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp', keyword_length = 2 },
      { name = 'buffer', keyword_length = 2 },
      { name = 'path', keyword_length = 3 },
      { name = 'cmdline', keyword_length = 2 },
      { name = 'luasnip', keyword_length = 2 },
      { name = 'calc', keyword_length = 2 },
    }, { name = 'buffer' }),
  }

  -- Set colorscheme
  vim.g.dracula_transparent_bg = false
  vim.cmd[[colorscheme dracula]]

end)
