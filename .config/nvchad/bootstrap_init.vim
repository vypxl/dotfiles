" This file's sole purpose is to install NvChad when Neovim is opened without
" NvChad already installed.

echom system('$HOME/.config/nvchad/install')
echo 'Done!'
echo 'Starting NvChad...'

" This is needed because for some reason neovim won't find init.lua at this point
execute 'lua ' .. system('cat $HOME/.config/nvim/init.lua')
