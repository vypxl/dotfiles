# Env
set -gx PATH $PATH $HOME/.dotnet/tools
set -gx PATH $PATH $HOME/.ghcup/bin
set -gx PNPM_HOME "/home/thomas/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH $HOME/.nimble/bin
set -gx PATH $PATH $HOME/.local/share/coursier/bin
if type -q ruby
    set -gx PATH $PATH (ruby -r rubygems -e 'puts Gem.dir+ "/bin"')
    set -gx PATH $PATH (ruby -r rubygems -e 'puts Gem.user_dir+ "/bin"')
end
set -gx PATH $PATH $HOME/.cargo/bin
set -gx PATH $PATH /usr/lib/emscripten
set -gx PATH /usr/lib/ccache/bin $PATH
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx SXHKD_SHELL /bin/sh
set -gx PYTHONSTARTUP $XDG_CONFIG_HOME/python/init.py
set -gx DEBUGINFOD_URLS (cat "/etc/debuginfod"/*.urls 2> /dev/null | tr '\n' ' ')
set -gx EDITOR vim
set -gx XMODIFIERS "@im=fcitx"
set -gx XMODIFIER "@im=fcitx"
set -gx GTK_IM_MODULE fcitx
set -gx QT_IM_MODULE fcitx
set -gx DefaultIMModule fcitx

# ssh agent
if not pgrep -u $USER ssh-agent >/dev/null
    ssh-agent -c >$XDG_RUNTIME_DIR/ssh-agent.env
end
source $XDG_RUNTIME_DIR/ssh-agent.env >/dev/null
set -gx SSH_ASKPASS /usr/bin/ksshaskpass
set -gx SSH_ASKPASS_REQUIRE prefer

# Prompt
if type -q starship
    starship init fish | source
end

# Completions
if type -q gh
    gh completion --shell fish | source
end

# fzf, fd, rg and friends
set -gx FZF_DEFAULT_COMMAND fd -Htf
set -gx FZF_DEFAULT_OPTS --height=20% --min-height=8 --border=rounded --margin=0,2 --layout=reverse
alias rg="rg --hidden"
alias zp="fzf --height=90% --preview-window=down:80% --preview='bat -n --color=always -r=:500 {}'"
alias zpg="fzf --height=90% --preview-window=down:80% --preview='bat -n --color=always -r=:500 (echo {} | cut -d: -f1)'"

function vz
    set f (zp)
    test -n "$f" && vim "$f"
end

function vgz
    if test (count $argv) -lt 1
        set argv ""
    end
    set f (rg $argv | zpg | cut -d: -f1)
    test -n "$f" && vim "$f"
end

function cz
    set d (fd -Htd | fzf)
    test -n "$d" && cd "$d"
end

function cgz
    if test (count $argv) -lt 1
        set argv ""
    end
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

function +
    echo $argv | jq -s add
end

function x
    echo $argv | jq -s 'reduce .[] as $item (1; . * $item)'
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
    paru -Syu
    echo "==> Updating ruby gems <=="
    gem update (gem outdated | cut -d ' ' -f 1)
    echo "==> Updating npm packages <=="
    pnpm update -g
    echo "==> Updating pip packages <=="
    pip list --format=freeze --user | cut -d = -f 1 \
        | xargs pip install --user --upgrade | grep -v already
    true
end

# Convenience Aliases
alias ls="exa --git"
alias ll="ls -l"
alias la="ls -al"
alias lr="la -R"
alias .=ll

alias vim=/usr/bin/nvim
alias nvim='/usr/bin/nvim "+lua require(\'persistence\').load()"'
alias hx=helix
alias ccopy="kitty +kitten clipboard"
alias cpaste="kitty +kitten clipboard --get-clipboard"
alias beep="aplay -q ~/.config/misc/beep.wav"
alias pluto="julia -ie 'import Pluto; Pluto.run()'"
alias icat="kitty +kitten icat"
alias ssh="kitty +kitten ssh"
alias lazyyadm="lazygit -w ~ -g ~/.local/share/yadm/repo.git"

alias killbg="jobs -p | tail -n 1 | xargs kill -9; fg"

abbr -a g git
abbr -a ga. git add .
abbr -a ga git add
abbr -a gst git status
abbr -a gcm git commit -m
abbr -a gcam git commit -am
abbr -a gc git checkout
abbr -a gp git push --all
abbr -a gpl git pull

abbr -a d docker
abbr -a dc docker compose
abbr -a dcu docker compose up
abbr -a dcud docker compose up -d
abbr -a dcd docker compose down
abbr -a dcs docker compose stop

abbr -a md mkdir
abbr -a pn pnpm
abbr -a cht cht.sh
abbr -a m clac
abbr -a j just

abbr -a rem remember
function c
    set r (_c $argv)
    if test $status -eq 0
        cd $r
    else
        echo $r
    end
end

# tabtab source for packages
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and source ~/.config/tabtab/fish/__tabtab.fish; or true

# opam configuration
source /home/thomas/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true

# zoxide
zoxide init fish | source

# pyenv
pyenv init - | source
