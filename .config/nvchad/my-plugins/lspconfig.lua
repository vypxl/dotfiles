local M = { "neovim/nvim-lspconfig" }

M.config = function()
  require("plugins.configs.lspconfig")

  local on_attach = require("plugins.configs.lspconfig").on_attach
  local capabilities = require("plugins.configs.lspconfig").capabilities

  local lspconfig = require("lspconfig")
  local configs = require("lspconfig.configs")

  local servers = {
    "awk_ls",
    "bashls",
    "clangd",
    "cmake",
    "crystalline",
    "csharp_ls",
    "elixirls",
    "emmet_ls",
    "gopls",
    "haxe_language_server",
    "hls",
    "html",
    "jsonls",
    "ocamllsp",
    "pyright",
    "marksman",
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
  }

  if not configs.emmet_ls then
    configs["emmet_ls"] = {
      default_config = {
        cmd = { "ls_emmet", "--stdio" },
        filetypes = {
          "html",
          "css",
          "scss",
          "javascriptreact",
          "typescriptreact",
          "haml",
          "xml",
          "xsl",
          "pug",
          "slim",
          "sass",
          "stylus",
          "less",
          "sss",
          "hbs",
          "handlebars",
          "svelte",
          "vue",
        },
        root_dir = function(fname)
          return vim.loop.cwd()
        end,
        settings = {},
      },
    }
  end

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end

  -- Fix clangd 'multiple different client offset encodings' warning
  local clangd_capabilities = capabilities
  clangd_capabilities.offsetEncoding = "utf-8"
  lspconfig.clangd.setup({
    on_attach = on_attach,
    capabilities = clangd_capabilities,
  })

  -- Custom config for eslint
  local eslint_capabilities = capabilities
  eslint_capabilities.formatting = true
  lspconfig.eslint.setup({
    on_attach = on_attach,
    capabilities = eslint_capabilities,
  })
end

return M
