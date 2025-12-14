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

  my.niri.enable = true;
  my.hyprland.enable = false;

  my.android.enable = true;

  networking.hostName = "slate";
  time.timeZone = "Europe/Zurich";

  fileSystems = {
    "/".options = [ "compress=zstd" ];
  };

  system.stateVersion = "24.11";
}
