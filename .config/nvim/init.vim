let $BASEDIR = $HOME.'/.config/nvim'
set shell=bash
" Plugins

set nocompatible "iMproved!
"filetype off

set rtp+=$BASEDIR/vundle/Vundle.vim/
call vundle#begin('$BASEDIR/vundle/')

Plugin 'VundleVim/Vundle.vim'
Plugin 'dracula/vim'
Plugin 'vim-airline/vim-airline'

Plugin 'airblade/vim-gitgutter'
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat'
Plugin 'ctrlpvim/ctrlp.vim'

Plugin 'sheerun/vim-polyglot'

call vundle#end()

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1


" config

syntax enable
let g:dracula_colorterm = 0
set termguicolors
color dracula

set hidden

set tabstop=2
set softtabstop=2
set smarttab
set expandtab
set number
set showcmd
set showmode
set wildmenu
set showmatch
set ruler
set history=10000
set undolevels=10000
set wildignore=*.swp,*.bak,*.pyc,*.class
set title
set visualbell
set noerrorbells
set list
set listchars=tab:▸\ ,trail:.,extends:#
set ignorecase
set smartcase

set laststatus=2

set pastetoggle=<F2>
set splitright

set incsearch

set foldenable
set foldlevelstart=10
set foldmethod=syntax

set encoding=utf-8
set autoindent
set copyindent
set shiftwidth=2

" Keybinding

let mapleader=" "

" Vim config edit and reload
nnoremap <leader>ev :split $MYVIMRC<CR>
nnoremap <leader>sv :w<CR>:source $MYVIMRC<CR>

" Toggle hlsearch
nnoremap <leader>h :set hlsearch! hlsearch?<CR>

" Make :; usable
nnoremap ; :

" Arrow keys as Buffer and Tab switchers
nnoremap <UP> :tabnext<CR>
nnoremap <DOWN> :tabprev<CR>
nnoremap <LEFT> :bp<CR>
nnoremap <RIGHT> :bn<CR>

" Moving lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Add blank line
nnoremap <Enter> o<ESC>

" Backup autosave swapfile
set backup
set backupdir=$BASEDIR/backup/
set directory=$BASEDIR/swapfiles
set writebackup

" functions

" :rc to read in ex commands like :rc ruby (1..9).map(&:to_s).join(', ')
function! _readcommand(cmd)
  try
    let l:result = execute(a:cmd, "silent")[1:] " strip the lf at the front which I cannot get rid of for some reason
    call setreg("r", l:result)
    normal "rp
  catch
    echoe v:exception
  endtry
  " echoerr v:exception
endfunction
command! -nargs=+ -complete=command ReadCommand call _readcommand(<q-args>)
cnoreabbrev rc ReadCommand

" shortcut for reading in ruby expressions (they will be `print`-ed out)
command! -nargs=+ -complete=command ReadRuby call _readcommand("ruby print " . <q-args>)
cnoreabbrev rr ReadRuby

