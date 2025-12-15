{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos
    # TODO: move to NixOS official repo when merged
    "${builtins.fetchGit { url = "https://github.com/cgrohs27/nixos-hardware.git"; rev = "64bb927d282e67f9b37be2b5c1bd8ce3b73178d2"; }}/asus/zephyrus/ga403"
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_17;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  my.bundle.desktop.enable = true;

  my.niri.enable = true;
  my.hyprland.enable = false;

  my.boot.splash = true;
  my.boot.limit-entries = 2;
  my.gdm.autologin = true;
  my.networking.dns.enable = false;

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
