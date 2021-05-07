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
set -gx EDITOR "vim"

# Completions
gh completion --shell fish | source

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

function join
    ruby -e "if not STDIN.tty? then puts STDIN.read.split(\"\n\").join(ARGV.length > 0 ? ARGV[0] : '') else puts File.read(ARGV[0]).split(\"\n\").join(ARGV.length > 1 ? ARGV[1] : '') end" $argv
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

function dev
    if test -e "package-lock.json"
        npm run dev
    else if test -e "pnpm-lock.yaml"
        pnpm run dev
    else if test -e "yarn.lock"
        yarn dev
    else
        live-server
    end
end

# Convenience Aliases
alias ls="exa --git"
alias ll="ls -l"
alias la="ls -al"
alias lr="la -R"
alias .=ll

alias vim=nvim
alias cclip="xclip -selection clipboard"
alias beep="aplay -q ~/.config/misc/beep.wav"
alias pluto="julia -ie 'import Pluto; Pluto.run()'"

abbr md mkdir
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
