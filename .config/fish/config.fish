# Env
set -gx PATH $PATH $HOME/.local/bin 
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

# Prompt
starship init fish | source

# Completions
gh completion --shell fish | source

# fzf, fd, rg and friends
set -gx FZF_DEFAULT_COMMAND fd -Htf
set -gx FZF_DEFAULT_OPTS --height=20% --min-height=8 --border=rounded --margin=0,2 --layout=reverse
alias z=fzf
alias rg="rg --hidden"

function vz
  set f (zp)
  test -n "$f" && vim "$f"
end

alias z=fzf

function vgz
  if test (count $argv) -lt 1; set argv ""; end
  set f (rg $argv | zpg | cut -d: -f1)
  test -n "$f" && vim "$f"
end

function cz
  set d (fd -Htd | fzf)
  test -n "$d" && cd "$d"
end

function cgz
  if test (count $argv) -lt 1; set argv ""; end
  set d (rg $argv | zpg | cut -d: -f1 | xargs dirname)
  test -n "$d" && cd "$d"
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

function join
    ruby -e "if not STDIN.tty? then puts STDIN.read.split(\"\n\").join(ARGV.length > 0 ? ARGV[0] : '') else puts File.read(ARGV[0]).split(\"\n\").join(ARGV.length > 1 ? ARGV[1] : '') end" $argv
end

function _latest_command
  commandline -r $history[1]
  commandline -f execute
end
bind \cr _latest_command

function pls
  if test (count $argv) -lt 1
    commandline -r "sudo $history[1]"
    commandline -f execute
  else
    sudo $argv
  end
end

function reload
  source ~/.config/fish/config.fish
end

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
alias ls="exa --git"
alias ll="ls -l"
alias la="ls -al"
alias lr="la -R"
alias .=ll

alias vim=nvim
alias cclip="xclip -selection clipboard"
alias beep="aplay -q ~/.config/misc/beep.wav"
alias pluto="julia -ie 'import Pluto; Pluto.run()'"
alias icat="kitty +kitten icat"

abbr -a md mkdir
abbr -a g   git
abbr -a ga. git add .
abbr -a ga  git add
abbr -a gst git status
abbr -a gcm git commit -m
abbr -a gc  git checkout
abbr -a gp  git push --all
abbr -a gpl git pull

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
