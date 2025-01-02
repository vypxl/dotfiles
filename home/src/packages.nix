pkgs: with pkgs; {
  base = [
    just
    inetutils
    nmap
    htop
    btop
    imagemagick
    tealdeer
    clac
    libqalculate
    zip
    unzip
    file
    wget
    pandoc
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
    ffmpeg

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
  ];
  graphical = [
    brave
    firefox
    ferdium
    google-chrome
    nautilus # file manager
    nautilus-open-any-terminal # to open kitty instead of gnome-terminal
    sushi # previewer for nautilus
    pavucontrol
    spotifywm
    vlc
    vscodium-fhs
    wl-clipboard-rs
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
    rust-analyzer
    svelte-language-server
    tailwindcss-language-server
    taplo # toml
    texlab
    typescript-language-server
    typst-lsp
    typstyle
    vscode-langservers-extracted
    yaml-language-server
  ];
  languages = [
    lua
    python3
    nodejs
    deno
    ruby
    rustc
    cargo
    ghc
  ];
}
