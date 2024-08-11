local function setup_lspconfig()
  local on_attach = function(client, _)
    if not client.supports_method "textDocument/semanticTokens" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }

  require("lspconfig").lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,

    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
            [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  }

  local lspconfig = require "lspconfig"

  local servers = {
    "awk_ls",
    "bashls",
    "clangd",
    "cmake",
    "crystalline",
    "csharp_ls",
    "elixirls",
    "emmet_ls",
    "gdscript",
    "glsl_analyzer",
    "gopls",
    "haxe_language_server",
    "hls",
    "html",
    "jsonls",
    "pyright",
    "marksman",
    "rnix",
    "solargraph",
    "svelte",
    "tailwindcss",
    "taplo",
    "tsserver",
    "typst_lsp",
    "volar",
    "yamlls",
    "zls",
  }

  lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        check = { command = "clippy" },
      },
    },
  }

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end

  -- Fix clangd 'multiple different client offset encodings' warning
  local clangd_capabilities = capabilities
  clangd_capabilities.offsetEncoding = "utf-8"
  lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = clangd_capabilities,
  }

  -- Custom config for eslint
  local eslint_capabilities = capabilities
  eslint_capabilities.formatting = true
  lspconfig.eslint.setup {
    on_attach = on_attach,
    capabilities = eslint_capabilities,
  }
end

local conform_opts = {
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
  default_format_opts = {
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua", prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } }
  }
}

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
    vim.print("Disabled autoformatting for this buffer")
  else
    vim.g.disable_autoformat = true
      vim.print("Disabled autoformatting globally")
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
  vim.print("Enabled autoformatting")
end, {
  desc = "Re-enable autoformat-on-save",
})

vim.api.nvim_create_user_command("FormatToggle", function(args)
  if vim.b.disable_autoformat or vim.g.disable_autoformat then
    vim.cmd("FormatEnable")
  else
    if args.bang then
      vim.cmd("FormatDisable!")
    else
      vim.cmd("FormatDisable")
    end
  end
end, {
  desc = "Toggle autoformat-on-save"
})

return {
  -- Lsp configuration presets
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    event = "VeryLazy",
    config = setup_lspconfig,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ComformInfo" },
    keys = {
      {
        "<leader>m",
        "<cmd>lua require('conform').format({ async = true })<CR>",
        mode = "n",
        desc = "forMat buffer"
      },
      {
        "<leader>M",
        "<cmd>FormatToggle!<CR>",
        mode = "n",
        desc = "Toggle automatic formatting on save"
      }
    },
    opts = conform_opts,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end
  }
}
