# Env
set -gx PATH $PATH $HOME/.pnpm-global/bin 
set -gx PATH $PATH $HOME/.nimble/bin
set -gx PATH $PATH (ruby -r rubygems -e 'puts Gem.dir+ "/bin"')
set -gx PATH $PATH (ruby -r rubygems -e 'puts Gem.user_dir+ "/bin"')
set -gx PATH $PATH $HOME/.cargo/bin
set -gx PATH $PATH /usr/lib/emscripten
set -gx PATH /usr/lib/ccache/bin $PATH
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx SXHKD_SHELL /bin/sh
set -gx PYTHONSTARTUP $XDG_CONFIG_HOME/python/init.py

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

function _latest_command
  commandline -r $history[1]
  commandline -f execute
end
bind \cr _latest_command

function update
  echo "==> Updating repository and AUR <=="
  yay -Syu
  echo "==> Updating ruby gems <=="
  gem update (gem outdated | cut -d ' ' -f 1)
  echo "==> Updating npm packages <=="
  pnpm update -g
  echo "==> Updating pip packages <=="
  pip list --format=freeze --user | cut -d = -f 1 \
    | xargs pip install --user --upgrade | grep -v "already"
  true
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
alias beep="aplay -q ~/.config/misc/beep.wav"

abbr -a g   git
abbr -a ga. git add .
abbr -a ga  git add
abbr -a gst git status
abbr -a gcm git commit -m

abbr -a pn pnpm
abbr -a cht cht.sh

abbr -a rem remember
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
