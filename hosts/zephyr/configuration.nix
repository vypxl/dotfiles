{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos
    # TODO: move to NixOS official repo when merged
    "${
      builtins.fetchGit {
        url = "https://github.com/vypxl/nixos-hardware.git";
        rev = "199d1f7a8d9fd55f26dc9659549a8c0a8f5a8a81";
      }
    }/asus/zephyrus/ga403"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  my.bundle.desktop.enable = true;

  my.niri.enable = true;
  my.hyprland.enable = false;

  my.boot.splash = true;
  my.boot.limit-entries = 2;
  my.gdm.autologin = true;
  my.networking.dns.enable = false;
  my.gaming.enable = true;

  environment.systemPackages = with pkgs; [
    _1password-gui
    _1password-cli
    unstable.stretchly
  ];

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    brlaser
    mfcl2700dnlpr
    mfcl2700dncupswrapper
  ];

  networking.hostName = "zephyr";
  time.timeZone = "Europe/Zurich";

  fileSystems = {
    "/".options = [ "compress=zstd" ];
  };

  system.stateVersion = "24.11";
}
