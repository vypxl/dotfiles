local present, null_ls = pcall(require, "null-ls")


if not present then
   return
end

local b = null_ls.builtins

local sources = {
   b.formatting.prettier,

   -- Lua
   b.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),
   b.formatting.clang_format,
}

null_ls.setup {
   debug = true,
   sources = sources,
}
