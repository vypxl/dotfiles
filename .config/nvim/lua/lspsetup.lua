return function(lsp, coq)
  local servers = {
    'sumneko_lua',
    'rust_analyzer',
    'gopls',
    'svelte',
    'tsserver',
    'pyright',
  }

  for _, serv in ipairs(servers) do
    lsp[serv].setup { }
    lsp[serv].setup(coq.lsp_ensure_capabilities { })
  end
end

