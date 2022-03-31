function map(mode, key, mapping, is_expr)
  for m in mode:gmatch"." do
    vim.api.nvim_set_keymap(m, key, mapping, { noremap = true, silent = true, unique = false, expr = is_expr or false })
  end
end

function nmap(key, mapping, is_expr)
  map('n', key, mapping, is_expr)
end

vim.g.mapleader = " "

-- Save with tt and C-s
nmap('tt', ':w<CR>')
map('i', '<C-s>', '<C-o>:w<CR>')

-- Quick edit and reload config
nmap("<leader>ev", ":edit $MYVIMRC")
nmap("<leader>sv", ":w,<CR>:source $MYVIMRC")

-- Disable hlsearch on second escape
-- or when entering insert mode
nmap("<Esc>", ":nohl<CR>")
vim.api.nvim_exec([[
  augroup nohlOnInsert
    au!
    au InsertEnter * setlocal nohlsearch
    au CmdlineEnter / setlocal hlsearch
    au CmdlineEnter ? setlocal hlsearch
  augroup END
]], false)

-- Remember cursor position when reopening files
vim.api.nvim_exec([[
  augroup vimrc-remember-cursor-position
      autocmd!
      autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | call timer_start(1, {tid -> execute("normal! zz")}) | endif
  augroup END
]], false)

-- Arrow keys as Buffer and Tab switchers
nmap('<UP>', ':tabnext<CR>')
nmap('<DOWN>', ':tabprev<CR>')
nmap('<LEFT>', ':bp<CR>')
nmap('<RIGHT>', ':bn<CR>')

-- Moving lines with alt
map('n', '<A-j>', ':m .+1<CR>==')
map('n', '<A-k>', ':m .-2<CR>==')
map('i', '<A-j>', '<C-o>:m .+1<CR>')
map('i', '<A-k>', '<C-o>:m .-2<CR>')
map('v', '<A-j>', ":m '>+1<CR>gv=gv")
map('v', '<A-k>', ":m '<-2<CR>gv=gv')")

-- Add blank line with enter
nmap('<Enter>', 'o<Esc>')

-- Switch windows with C-hjkl
nmap('<c-h>', ':wincmd h<CR>')
nmap('<c-j>', ':wincmd j<CR>')
nmap('<c-k>', ':wincmd k<CR>')
nmap('<c-l>', ':wincmd l<CR>')

-- Plugins

-- nvim-tree
map('inv', '<c-b>', ':NvimTreeToggle<CR>')

-- Telescope
nmap('<leader>ff', ':lua require("telescope.builtin").find_files()<CR>')
nmap('<leader>fg', ':lua require("telescope.builtin").live_grep()<CR>')
nmap('<leader>fb', ':lua require("telescope.builtin").buffers()<CR>')
nmap('<leader>fh', ':lua require("telescope.builtin").help_tags()<CR>')

-- coc

-- Confirm completion with <TAB>
-- map('i', '<TAB>', 'pumvisible() ? coc#_select_confirm() : "<TAB>"', true)

vim.api.nvim_exec([[
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ Mappings_check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! Mappings_check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
]], false)
