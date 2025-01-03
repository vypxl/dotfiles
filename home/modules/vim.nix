{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    vim.enable = mkEnableOption "vim";
  };

  config = lib.mkIf cfg.vim.enable {
    programs.vim.enable = true;
    programs.vim.extraConfig = ''
      " Vim
      set nocompatible "iMproved!
      set shell=bash
      syntax enable
      set termguicolors

      set timeoutlen=200
      inoremap jk <Esc>
      inoremap kj <Esc>

      " No swap or backup
      set noswapfile
      set nobackup

      " Editing
      set tabstop=2
      set softtabstop=2
      set shiftwidth=2
      set smarttab
      set expandtab

      set autoindent
      set smartindent

      set encoding=utf-8

      " Editor
      set hidden

      set number
      set relativenumber
      set ruler

      set showcmd
      set showmode
      set showmatch
      set wildmenu
      set wildignore=*.swp,*.bak,*.pyc,*.class

      set title
      set novisualbell
      set noerrorbells

      set list
      set listchars=tab:▸\ ,trail:.,extends:#

      set splitright
      set splitbelow

      " Searching
      set ignorecase
      set smartcase
      set incsearch

      " Folding
      set foldenable
      set foldnestmax=2
      set foldmethod=expr

      " Keybindings

      let mapleader=" "

      " Disable hlsearch with second escape
      " and when entering insert mode
      nnoremap-silent <Esc> :nohl<CR>
      augroup nohlOnInsert
        au!
        au InsertEnter * setlocal nohlsearch
        au CmdlineEnter / setlocal hlsearch
        au CmdlineEnter ? setlocal hlsearch
      augroup END

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

      " Add blank line with enter
      nnoremap <Enter> o<ESC>
    '';
  };
}
