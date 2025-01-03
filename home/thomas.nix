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
    ./modules/direnv.nix
    ./modules/dunst.nix
    ./modules/fish.nix
    ./modules/fuzzel.nix
    ./modules/git.nix
    ./modules/gnome-keyring.nix
    ./modules/helix.nix
    ./modules/hyprland.nix
    ./modules/kitty.nix
    ./modules/lazygit.nix
    ./modules/nvim.nix
    ./modules/python.nix
    ./modules/scripts.nix
    ./modules/shell-utils.nix
    ./modules/ssh.nix
    ./modules/syncthing.nix
    ./modules/vim.nix
    ./modules/waybar.nix
    ./modules/wlogout.nix
    ./modules/xkb.nix
    ./modules/yamllint.nix
    ./modules/zed.nix
    ./modules/zellij.nix
  ];

  home.packages =
    with import ./src/packages.nix pkgs;
    lib.lists.concatLists [
      base
      graphical
      lsp
      languages
    ];

  services.udiskie.enable = true;
  services.mpris-proxy.enable = true; # bt media control

  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile."file_templates" = dotfile_dir "file_templates";

  home.stateVersion = "24.11";
}
