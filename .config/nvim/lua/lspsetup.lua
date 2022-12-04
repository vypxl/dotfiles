local lspc = require('lspconfig')
local configs = require('lspconfig.configs')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Custom configurations

if not configs.ls_emmet then
  configs.ls_emmet = {
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

-- Simple setups

local simple_servers = {
  'rust_analyzer',
  'gopls',
  'svelte',
  'tsserver',
  'pyright',
  'ls_emmet',
  'clangd',
  'hls',
}

for _, serv in pairs(simple_servers) do
  lspc[serv].setup {
    capabilities = capabilities,
  }
end

-- Custom configurations

lspc.sumneko_lua.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) }
    }
  }
}
