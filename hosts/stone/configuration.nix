{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos
  ];

  my.bundle.desktop.enable = true;

  my.boot.splash = true;
  my.gdm.autologin = true;
  my.networking.dns.enable = true;

  networking.hostName = "stone";
  time.timeZone = "Europe/Berlin";

  fileSystems = {
    "/".options = [ "compress=zstd" ];
  };

  system.stateVersion = "24.11";
}
