{ config, lib, ... }:
let
  cfg = config.my.bundle;
in
{
  imports = [
    ./modules/android.nix
    ./modules/audio.nix
    ./modules/auto-upgrade.nix
    ./modules/base.nix
    ./modules/bluetooth.nix
    ./modules/boot.nix
    ./modules/command-not-found.nix
    ./modules/docker.nix
    ./modules/fish.nix
    ./modules/hyprland.nix
    ./modules/gdm.nix
    ./modules/locale.nix
    ./modules/networking.nix
    ./modules/nix.nix
    ./modules/sudo.nix
    ./modules/swapfile.nix
    ./modules/user.nix
  ];

  options.my.bundle = with lib; {
    default.enable = mkOption {
      type = types.bool;
      description = "Enable default modules for nixos configuration";
      default = true;
    };

    desktop.enable = mkOption {
      type = types.bool;
      description = "Enable modules for nixos Desktop experience";
      default = false;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.default.enable {
      my.auto-upgrade.enable = true;
      my.base.enable = true;
      my.boot.enable = true;
      my.docker.enable = true;
      my.fish.enable = true;
      my.locale.enable = true;
      my.networking.enable = true;
      my.nix.enable = true;
      my.sudo.enable = true;
      my.swapfile.enable = true;
      my.user.enable = true;
    })

    (lib.mkIf cfg.desktop.enable {
      my.audio.enable = true;
      my.bluetooth.enable = true;
      my.hyprland.enable = true;
      my.gdm.enable = true;
      my.networking.dns.enable = lib.mkDefault true;
    })
  ];
}
