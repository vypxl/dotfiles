let $BASEDIR = $HOME.'/.config/nvim'
set shell=bash
" Plugins

set nocompatible "iMproved!
"filetype off

set rtp+=$BASEDIR/vundle/Vundle.vim/
call vundle#begin('$BASEDIR/vundle/')

Plugin 'VundleVim/Vundle.vim'
Plugin 'dracula/vim'

call vundle#end()

" config

syntax enable
color dracula
set termguicolors

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

" Disable Arrow keys
nnoremap <UP> <NOP>
nnoremap <DOWN> <NOP>
nnoremap <LEFT> <NOP>
nnoremap <RIGHT> <NOP>

" Backup autosave swapfile
set backup
set backupdir=$BASEDIR/backup/
set directory=$BASEDIR/swapfiles
set writebackup
