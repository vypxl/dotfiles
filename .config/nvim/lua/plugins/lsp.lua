local function setup_lspconfig()
  local on_attach = function(client, _)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

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

local function setup_null_ls()
  local null_ls = require "null-ls"
  local b = null_ls.builtins
  local fmt = b.formatting
  local diag = b.diagnostics
  local ca = b.code_actions

  local sources = {
    fmt.alejandra,
    fmt.asmfmt,
    fmt.beautysh,
    fmt.black,
    fmt.brittany, -- Haskell
    fmt.buildifier,
    fmt.cabal_fmt,
    fmt.cbfmt,
    fmt.clang_format,
    fmt.cljstyle,
    fmt.cmake_format,
    fmt.crystal_format.with { extra_args = { "-" } },
    fmt.dfmt,
    fmt.fish_indent,
    fmt.fixjson,
    fmt.fnlfmt,
    fmt.gdformat,
    fmt.gofmt,
    fmt.goimports,
    fmt.google_java_format,
    fmt.isort, -- Python
    fmt.jq, -- JSON
    fmt.ktlint,
    fmt.latexindent,
    fmt.markdownlint,
    fmt.mix, -- Elixir
    fmt.nginx_beautifier,
    fmt.nimpretty,
    fmt.nixfmt,
    fmt.ocdc, -- Changelogs
    fmt.prettierd,
    fmt.prismaFmt,
    fmt.protolint,
    fmt.ptop,
    fmt.rubocop,
    fmt.rustfmt.with { extra_args = { "--edition=2021" } },
    fmt.scalafmt,
    fmt.stylua.with { extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
    fmt.surface, -- Phoenix
    fmt.swiftformat,
    fmt.taplo,
    fmt.yamlfmt,
    fmt.zigfmt,

    diag.buildifier,
    diag.checkmake,
    diag.checkstyle,
    diag.chktex,
    diag.clj_kondo,
    diag.cmake_lint,
    diag.credo,
    diag.dotenv_linter,
    diag.fish,
    diag.gdlint,
    diag.hadolint,
    diag.jsonlint,
    diag.ktlint,
    diag.misspell,
    diag.protolint,
    diag.pydocstyle,
    diag.pylint,
    diag.revive,
    diag.selene,
    diag.shellcheck,
    diag.statix,
    diag.swiftlint,
    diag.tidy,
    diag.tsc,
    diag.yamllint,

    ca.shellcheck,
    ca.statix,
  }

  null_ls.setup {
    debug = false,
    sources = sources,
  }
end

return {
  -- Tool to install lsp's
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    config = true,
  },

  -- Integrate mason with lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    opts = { automatic_installation = true },
  },

  -- Lsp configuration presets
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    event = "VeryLazy",
    config = setup_lspconfig,
  },

  -- Integrate null-ls with lspconfig
  {
    "jay-babu/mason-null-ls.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
    opts = {
      ensure_installed = nil,
      automatic_installation = true,
    },
  },

  -- Drop in replacement for null-ls
  -- A tool to integrate linters, formatters and diagnostic sources with nvim-lsp
  {
    "nvimtools/none-ls.nvim",
    config = setup_null_ls,
  },
}
