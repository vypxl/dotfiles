{
  config,
  pkgs,
  lib,
  ...
}:
with import ./src/util.nix config;
{
  xdg.enable = true;
  imports = [
    ./modules/bat.nix
    ./modules/dunst.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/helix.nix
    ./modules/hyprland.nix
    ./modules/kitty.nix
    ./modules/lazygit.nix
    ./modules/nvim.nix
    ./modules/python.nix
    ./modules/rofi.nix
    ./modules/shell-utils.nix
    ./modules/ssh.nix
    ./modules/tmux.nix
    ./modules/touchegg.nix
    ./modules/vim.nix
    ./modules/waybar.nix
    ./modules/wlogout.nix
    ./modules/xkb.nix
    ./modules/yamllint.nix
    ./modules/zed.nix
  ];

  home.packages =
    with import ./src/packages.nix pkgs;
    lib.lists.concatLists [
      base
      graphical
      lsp
      languages
      [
        pkgs.seahorse
        pkgs.gcr
      ]
    ];

  services.udiskie.enable = true;
  services.gnome-keyring.enable = true;
  programs.fish.shellInit = ''
    set -gx SSH_AUTH_SOCK /run/user/(id -u)/keyring/ssh
  '';
  # programs.seahorse.enable = true;
  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile."file_templates" = dotfile_dir "file_templates";

  home.stateVersion = "24.11";
}
