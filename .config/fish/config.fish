# Env
set -gx PATH $PATH $HOME/.yarn/bin 
set -gx PATH $PATH $HOME/.nimble/bin
set -gx PATH $PATH (ruby -r rubygems -e 'puts Gem.dir+ "/bin"')
set -gx PATH $PATH (ruby -r rubygems -e 'puts Gem.user_dir+ "/bin"')
set -gx PATH $PATH /usr/lib/emscripten
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx SXHKD_SHELL /bin/sh
set -gx PYTHONSTARTUP $XDG_CONFIG_HOME/python/init.py

source ~/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# Fisher
if not functions -q fisher
    curl https://git.io/fisher --create-dirs -sLo ~/.dotfiles/files/fish/functions/fisher.fish
    fish -c fisher
end

# Convenience Functions
function cdd
  command mkdir -p $argv
  cd $argv
end

function fork
  if test (count $argv) -lt 1
    # echo "Please specify command to fork!!"
    fork kitty
  else
    ruby -e "require 'open3'; fork do; Open3.capture3(ARGV.join('')); end" $argv
  end
end

# Convenience Aliases
alias ls="ls -h --color=always"
alias la="ls -Al"
alias lr="ls -AlR"
alias li="ls -Ali"
alias .=ll

alias vim=nvim
alias md=mkdir
alias cclip="xclip -selection clipboard"

alias g=git
alias ga.="git add ."
alias ga="git add"
alias gst="git status"
alias gcm="git commit -m"

alias rem=remember
function c
    set r (_c $argv)
    if test $status -eq 0
        cd $r
    else
        echo $r
    end
end

#lol
function "commit die"
  systemctl poweroff
end
function "commit live"
  systemctl reboot
end
function "commit sin"
  sudo /usr/bin/startwin
end


bind "&&" 'commandline -i ";"'
