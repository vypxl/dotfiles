-- nvim-cmp - everything related to autocompletion
return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    {
      -- snippet plugin
      "L3MON4D3/LuaSnip",
      dependencies = "rafamadriz/friendly-snippets",
      config = function()
        local ls = require "luasnip"
        require("luasnip.loaders.from_vscode").lazy_load()
        ls.config.set_config {
          history = true,
          updateevents = "TextChanged,TextChangedI",
        }

        -- Exit snippet context when leaving insert mode
        vim.api.nvim_create_autocmd("InsertLeave", {
          callback = function()
            if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.session.jump_active then
              ls.unlink_current()
            end
          end,
        })
      end,
    },

    -- autopairing of (){}[] etc
    {
      "windwp/nvim-autopairs",
      opts = {
        fast_wrap = {},
        disable_filetype = { "TelescopePrompt", "vim" },
      },
      config = function(_, opts)
        require("nvim-autopairs").setup(opts)

        -- setup cmp for autopairs
        local cmp_autopairs = require "nvim-autopairs.completion.cmp"
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },

    {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
    },

    -- nice icons for cmp
    "onsails/lspkind.nvim",
  },

  config = function()
    local cmp = require "cmp"
    local lspkind = require "lspkind"
    lspkind.symbol_map["Copilot"] = ""
    lspkind.symbol_map["Codeium"] = ""
    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { link = "CmpItemKindSnippet" })
    vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { link = "CmpItemKindSnippet" })

    local function border(hl_name)
      return {
        { "╭", hl_name },
        { "─", hl_name },
        { "╮", hl_name },
        { "│", hl_name },
        { "╯", hl_name },
        { "─", hl_name },
        { "╰", hl_name },
        { "│", hl_name },
      }
    end

    local opts = {
      mapping = {
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<Tab>"] = function(fallback)
          local ls = require "luasnip"

          if cmp.visible() then
            cmp.confirm { select = true }
          elseif ls.expand_or_locally_jumpable() then
            ls.expand_or_jump()
          else
            fallback()
          end
        end,
        ["<S-Tab>"] = function(fallback)
          local ls = require "luasnip"
          if ls.jumpable(-1) then
            ls.jump(-1)
          else
            fallback()
          end
        end,
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      completion = {
        keyword_length = 1,
      },
      window = {
        completion = {
          border = border "CmpBorder",
        },
        documentation = {
          border = border "CmpBorder",
        },
      },
      formatting = {
        format = function(entry, vim_item)
          local max_width = 40
          vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol_text" })
          vim_item.menu = "(" .. entry.source.name .. ")"

          if vim.fn.strchars(vim_item.abbr) > max_width then
            vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, max_width) .. "…"
          end

          return vim_item
        end,
      },
      sources = cmp.config.sources {
        { name = "nvim_lsp", group_index = 1 },
        { name = "path", group_index = 1 },
        { name = "luasnip", group_index = 1 },
        { name = "nvim_lua", group_index = 1 },
        { name = "buffer", group_index = 2, keyword_length = 3 },
        { name = "calc" },
      },
      enabled = function()
        -- disable if inside an ephemeral buffer (popups like renamer)
        if vim.o.bufhidden == "wipe" then
          return false
        end
        return true
      end,
      experimental = {
        ghost_text = true,
      },
    }
    cmp.setup(opts)
  end,
}
