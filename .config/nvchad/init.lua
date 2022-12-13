require("custom.options")

-- Remember cursor position when reopening files
vim.api.nvim_exec([[
  augroup vimrc-remember-cursor-position
      autocmd!
      autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | call timer_start(1, {tid -> execute("normal! zz")}) | endif
  augroup END
]], false)
