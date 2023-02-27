require './util'

PACKAGES = %w[
  base-devel
  busybox
  inetutils
  iputils
  binutils
  coreutils
  nmap
  gnu-netcat
  htop
  imagemagick
  zathura
  zathura-pdf-mupdf
  tealdeer
  zoxide
  zip
  unzip
  wget
  pandoc-bin
  ghostscript
  texlive-core
  syncthing
  syncthingtray

  vim
  neovim-nigthly-bin
  nvim-packer-git
  fd
  jq
  fq
  ripgrep
  fzf
  bat
  exa
  github-cli
  xclip

  fish
  starship
  kitty

  lolcat
  cowsay
  sl
  bash-pipes
  cmatrix
  fastfetch
  onefetch
  scc

  jdk11-openjdk
  crystal
  ameba
  rustup
  go
  ghcup-hs-bin
  python
  python-pip
  ocaml
  opam
  haxe
  nimble
  pypy3
  julia
  clang
  cmake
  bazel
  ninja
  gdb
  emscripten
  docker
  entr
  tidy

  touchegg
  touche

  brave-bin
  google-chrome
  firefox
  jellyfin-media-player
  logseq-desktop-bin
  stretchly-bin
  spotify
  discord-canary
  vlc
  visual-studio-code-bin

  ttf-fira-code
  nerd-fonts-complete-starship

  glm
  sdl
  sdl2
  sfml
  freetype2
]

RUBY_PACKAGES = %w[
  neovim
  rake
  rails
  solargraph
  terutil
]

NPM_PACKAGES = %w[
  firebase-tools
  live-server
  n
  neovim
  pnpm
  yarn
  graphql
  graphql-language-service-cli
  typescript
  ls_emmet
]

PYTHON_PACKAGES = %w[
  conan
  neovim
  networkx
  numpy
  pyright
  pwntools
  toolz
]

# TODO!!!
def install_rust
  # if not installed:
  log_exec_fail 'sudo rustup install nightly'
end

def install_node
  `bash -c "command -v n"`
  return if $?.success?

  puts 'Installing NodeJS'
  log_exec_fail 'curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o /tmp/n'
  log_exec_fail 'sudo bash /tmp/n lts'
  log_exec_fail 'npx --yes pnpm i -g pnpm'
  log_exec_fail 'rm /tmp/n'
end

def install_system_packages
  pkgs = PACKAGES.join ' '
  puts 'Installing System Packages'
  log_exec_fail "paru -S --needed --noconfirm #{pkgs}"
end

def install_ruby_packages
  pkgs = RUBY_PACKAGES.join ' '
  puts 'Installing Ruby gems'
  log_exec_fail "gem install --conservative #{pkgs}"
end

def install_python_packages
  pkgs = PYTHON_PACKAGES.join ' '
  puts 'Installing Python (and PyPy) packages'
  log_exec_fail "pip install --user #{pkgs}"
  log_exec_fail 'pypy3 -m ensurepip --user'
  log_exec_fail "pypy3 -mpip install --user #{pkgs}"
end

def install_npm_packages
  pkgs = NPM_PACKAGES.join ' '
  puts 'Installing global npm packages'
  log_exec_fail "pnpm i -g #{pkgs}"
end

def install_packages
  install_system_packages
  install_node

  install_ruby_packages
  install_npm_packages
  install_python_packages
end
