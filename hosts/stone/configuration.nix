{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/modules/audio.nix
    ../../nixos/modules/base.nix
    ../../nixos/modules/boot.nix
    ../../nixos/modules/docker.nix
    ../../nixos/modules/fish.nix
    ../../nixos/modules/font.nix
    ../../nixos/modules/hyprland.nix
    ../../nixos/modules/gdm.nix
    ../../nixos/modules/locale.nix
    ../../nixos/modules/networking.nix
    ../../nixos/modules/nix.nix
    ../../nixos/modules/plymouth.nix
    ../../nixos/modules/services.nix
    ../../nixos/modules/sudo.nix
    ../../nixos/modules/swapfile.nix
    ../../nixos/modules/user.nix
  ];

  networking.hostName = "stone";
  time.timeZone = "Europe/Berlin";

  fileSystems = {
    "/".options = [ "compress=zstd" ];
  };

  system.stateVersion = "24.11";
}
