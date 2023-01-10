local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

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
  fmt.buf,
  fmt.buildifier,
  fmt.cabal_fmt,
  fmt.cbfmt,
  fmt.clang_format,
  fmt.cljstyle,
  fmt.cmake_format,
  fmt.crystal_format,
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
  fmt.rustfmt,
  fmt.rustywind,
  fmt.scalafmt,
  fmt.standardrb,
  fmt.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),
  fmt.surface, -- Phoenix
  fmt.swiftformat,
  fmt.taplo,
  fmt.tidy,
  fmt.yamlfmt,
  fmt.zigfmt,

  diag.alex,
  diag.buf,
  diag.buildifier,
  diag.checkmake,
  diag.checkstyle,
  diag.chktex,
  diag.clj_kondo,
  diag.cmake_lint,
  diag.codespell,
  diag.cppcheck,
  diag.cpplint,
  diag.credo,
  diag.dotenv_linter,
  diag.eslint_d,
  diag.fish,
  diag.gdlint,
  diag.hadolint,
  diag.jshint,
  diag.jsonlint,
  diag.ktlint,
  diag.markdownlint,
  diag.misspell,
  diag.protolint,
  diag.pycodestyle,
  diag.pydocstyle,
  diag.pylint,
  diag.revive,
  diag.selene,
  diag.shellcheck,
  diag.standardrb,
  diag.statix,
  diag.swiftlint,
  diag.tidy,
  diag.tsc,
  diag.yamllint,

  ca.cspell,
  ca.eslint_d,
  ca.gitsigns,
  ca.shellcheck,
  ca.statix,
}

null_ls.setup({
  debug = false,
  sources = sources,
})
