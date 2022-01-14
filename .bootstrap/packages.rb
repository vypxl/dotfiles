require './util'

PACKAGES = %w(
  base-devel
  busybox
  inetutils
  binutils
  coreutils
  gnu-netcat
  htop
  imagemagick
  zip
  unzip
  wget
  pandoc

  vim
  neovim
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
  neofetch
  onefetch
  scc

  jdk11-openjdk
  crystal
  rustup
  go
  stack
  ghc
  python
  python-pip
  pypy3
  clang
  
  touchegg
  touche

  brave-bin
  google-chrome
  firefox
  stretchly-bin
  spotify
  discord-canary
  code

  ttf-fira-code
  otf-nerd-fonts-fira-code

  glm
  sdl
  sdl2
  sfml
  freetype2
)

RUBY_PACKAGES = %w(
  terutil
  rake
  rails
)

NPM_PACKAGES = %w(
  pnpm
  yarn
  n
  live-server
)

PYTHON_PACKAGES = %w(
  numpy
  networkx
  toolz
)

def install_node
  `bash -c "command -v node"`
  return if $?.success?

  puts "Installing NodeJS"
  log_exec_fail "curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o /tmp/n"
  log_exec_fail "sudo bash /tmp/n lts"
  log_exec_fail "npx --yes pnpm i -g pnpm"
  log_exec_fail "rm /tmp/n"
end

def install_system_packages
  pkgs = PACKAGES.join ' '
  puts "Installing System Packages"
  log_exec_fail "paru -S --needed --noconfirm #{pkgs}"
end

def install_ruby_packages
  pkgs = RUBY_PACKAGES.join ' '
  puts "Installing Ruby gems"
  log_exec_fail "gem install --conservative #{pkgs}"
end

def install_python_packages
  pkgs = PYTHON_PACKAGES.join ' '
  puts "Installing Python (and PyPy) packages"
  log_exec_fail "pip install --user #{pkgs}"
  log_exec_fail "pypy3 -m ensurepip --user"
  log_exec_fail "pypy3 -mpip install --user #{pkgs}" 
end

def install_npm_packages
  pkgs = NPM_PACKAGES.join ' '
  puts "Installing global npm packages"
  log_exec_fail "pnpm i -g #{pkgs}"
end

def install_packages
  install_system_packages
  install_node

  install_ruby_packages
  install_npm_packages
  install_python_packages
end

