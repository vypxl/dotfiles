local M = {
  "jose-elias-alvarez/null-ls.nvim",
  enabled = true,
  event = "VeryLazy",
  dependencies = { "nvim-lspconfig" },
}

M.config = function()
  local null_ls = require("null-ls")
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
    fmt.crystal_format.with({ extra_args = { "-" } }),
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
    fmt.ocamlformat,
    fmt.ocdc, -- Changelogs
    fmt.prettierd,
    fmt.prismaFmt,
    fmt.protolint,
    fmt.ptop,
    fmt.rubocop,
    fmt.rustfmt.with({ extra_args = { "--edition=2021" } }),
    fmt.scalafmt,
    fmt.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),
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
    diag.codespell.with({ extra_args = { "--ignore-words", "~/.config/.codespell_ignore" } }),
    diag.credo,
    diag.dotenv_linter,
    diag.fish,
    diag.gdlint,
    diag.hadolint,
    diag.jsonlint,
    diag.ktlint,
    diag.misspell,
    diag.protolint,
    diag.pycodestyle,
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

    ca.cspell,
    ca.shellcheck,
    ca.statix,
  }

  null_ls.setup({
    debug = false,
    sources = sources,
  })
end

return M