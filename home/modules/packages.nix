{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
with pkgs;
let
  base = [
    just
    inetutils
    nmap
    htop
    btop
    tealdeer
    clac
    libqalculate
    zip
    unzip
    file
    wget
    fd
    jq
    fq
    ripgrep
    ripgrep-all
    fzf
    bat
    eza
    delta
    gh
    glab
    entr
    live-server
    lazygit
    lshw
    dig
    socat
    tree

    lolcat
    cowsay
    sl
    pipes-rs
    cmatrix
    fastfetch
    scc

    autoconf
    automake
    bison
    cmake
    flex
    gcc
    gnumake
    ninja

    terraform
    google-cloud-sdk
  ];
  util = [
    imagemagick
    pandoc
    ffmpeg
    poppler-utils
    qmk
    unstable.aichat
  ];
  graphical = [
    brave
    bruno
    firefox
    unstable.ferdium
    google-chrome
    nautilus # file manager
    nautilus-open-any-terminal # to open kitty instead of gnome-terminal
    sushi # previewer for nautilus
    obsidian
    pavucontrol
    ripdrag
    spotifywm
    vlc
    vscodium-fhs
    wl-clipboard-rs
    wev
    wlr-randr
    zathura
  ];
  lsp = [
    bash-language-server
    clang-tools
    cmake-language-server
    crystalline
    csharp-ls
    elixir-ls
    emmet-ls
    gdtoolkit_4
    glsl_analyzer
    gopls
    haskell-language-server
    lua-language-server
    nixd
    nil
    nixfmt-rfc-style
    pyright
    marksman
    rubyPackages.solargraph
    svelte-language-server
    tailwindcss-language-server
    taplo # toml
    texlab
    tinymist
    typescript-language-server
    typstyle
    vscode-langservers-extracted
    yaml-language-server
  ];
  languages = [
    lua
    unstable.python312
    unstable.python312Packages.uv
    unstable.python312Packages.ruff
    nodejs
    deno
    yarn
    pnpm
    ruby
    ghc
  ];
  per-host = {
    zephyr = [
      # omnix.default
      unstable.vault
      remmina
    ];
  };
  cfg = config.my.packages;
in
{
  options.my.packages = with lib; {
    base = mkEnableOption "base";
    graphical = mkEnableOption "graphical";
    lsp = mkEnableOption "lsp";
    languages = mkEnableOption "languages";
    util = mkEnableOption "util";
  };

  config = {
    home.packages = lib.lists.concatLists [
      (if cfg.base then base else [ ])
      (if cfg.graphical then graphical else [ ])
      (if cfg.lsp then lsp else [ ])
      (if cfg.languages then languages else [ ])
      (if cfg.util then util else [ ])
      (lib.attrsets.attrByPath [ hostname ] [ ] per-host)
    ];
  };
}
