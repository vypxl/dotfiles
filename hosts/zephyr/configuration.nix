{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos
    # TODO: move to NixOS official repo when merged
    "${builtins.fetchGit { url = "https://github.com/cgrohs27/nixos-hardware.git"; rev = "64bb927d282e67f9b37be2b5c1bd8ce3b73178d2"; }}/asus/zephyrus/ga403"
  ];

  my.bundle.desktop.enable = true;

  my.boot.splash = true;
  my.gdm.autologin = true;
  my.networking.dns.enable = true;

  networking.hostName = "zephyr";
  time.timeZone = "Europe/Zurich";

  fileSystems = {
    "/".options = [ "compress=zstd" ];
  };

  system.stateVersion = "24.11";
}
