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
    ./modules/desktop.nix
    ./modules/docker.nix
    ./modules/fish.nix
    ./modules/gaming.nix
    ./modules/gdm.nix
    ./modules/k3s.nix
    ./modules/locale.nix
    ./modules/local-docker-image.nix
    ./modules/networking.nix
    ./modules/nix.nix
    ./modules/ssh.nix
    ./modules/sudo.nix
    ./modules/swap.nix
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
      my.auto-upgrade.enable = lib.mkDefault true;
      my.base.enable = lib.mkDefault true;
      my.boot.enable = lib.mkDefault true;
      my.docker.enable = lib.mkDefault true;
      my.fish.enable = lib.mkDefault true;
      my.locale.enable = lib.mkDefault true;
      my.networking.enable = lib.mkDefault true;
      my.nix.enable = lib.mkDefault true;
      my.sudo.enable = lib.mkDefault true;
      my.swap.enable = lib.mkDefault true;
      my.user.enable = lib.mkDefault true;
    })

    (lib.mkIf cfg.desktop.enable {
      my.audio.enable = lib.mkDefault true;
      my.bluetooth.enable = lib.mkDefault true;
      my.hyprland.enable = lib.mkDefault true;
      my.gdm.enable = lib.mkDefault true;
      my.networking.dns.enable = lib.mkDefault true;
    })
  ];
}
