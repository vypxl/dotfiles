{ lib, config, dankMaterialShell, ... }:
let
  cfg = config.my.bundle;
in
{
  imports = [
    dankMaterialShell.homeModules.dankMaterialShell.default
    ./modules/android.nix
    ./modules/bat.nix
    ./modules/desktop.nix
    ./modules/direnv.nix
    ./modules/dotfiles.nix
    ./modules/dunst.nix
    ./modules/file-templates.nix
    ./modules/fish.nix
    ./modules/fuzzel.nix
    ./modules/git.nix
    ./modules/gnome-keyring.nix
    ./modules/helix.nix
    ./modules/kitty.nix
    ./modules/lazygit.nix
    ./modules/nvim.nix
    ./modules/packages.nix
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

  options.my.bundle = with lib; {
    minimal.enable = mkOption {
      type = types.bool;
      description = "Enable default modules for minimal text-based environment";
      default = false;
    };

    desktop.enable = mkOption {
      type = types.bool;
      description = "Enable default modules for full-featured desktop environment";
      default = false;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.minimal.enable || cfg.desktop.enable) {
      # (lib.mkIf cfg.minilmal.enable {
      xdg.enable = true;
      home.sessionVariables.EDITOR = "nvim";

      my.packages.base = true;

      my.bat.enable = true;
      my.direnv.enable = true;
      my.fish.enable = true;
      my.file-templates.enable = true;
      my.git.enable = true;
      my.helix.enable = true;
      my.lazygit.enable = true;
      my.nvim.enable = true;
      my.python.enable = true;
      my.scripts.enable = true;
      my.shell-utils.enable = true;
      my.ssh.enable = true;
      my.vim.enable = true;
      my.yamllint.enable = true;
      my.zellij.enable = true;
    })

    (lib.mkIf cfg.desktop.enable {
      my.gnome-keyring.enable = true;
      my.kitty.enable = true;
      my.syncthing.enable = true;
      my.xkb.enable = true;
      my.zed.enable = true;

      my.packages.graphical = true;
      my.packages.lsp = true;
      my.packages.languages = true;
      my.packages.util = true;
    })
  ];
}
