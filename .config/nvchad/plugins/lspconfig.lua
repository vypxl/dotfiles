local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local configs = require "lspconfig.configs"
local servers = {
  "rust_analyzer",
  "gopls",
  "svelte",
  "pyright",
  "emmet-ls",
  "hls",
  "tsserver",
  "crystalline",
}

if not configs.ls_emmet then
  configs["emmet-ls"] = {
    default_config = {
      cmd = { 'ls_emmet', '--stdio' };
      filetypes = {
        'html',
        'css',
        'scss',
        'javascriptreact',
        'typescriptreact',
        'haml',
        'xml',
        'xsl',
        'pug',
        'slim',
        'sass',
        'stylus',
        'less',
        'sss',
        'hbs',
        'handlebars',
        'svelte',
        'vue',
      };
      root_dir = function(fname)
        return vim.loop.cwd()
      end;
      settings = {};
    };
  }
end

-- Fix clangd 'multiple different client offset encodings' warning
local clangd_capabilities = capabilities
clangd_capabilities.offsetEncoding = "utf-8"
lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = clangd_capabilities
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
