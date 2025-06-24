{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos
    # TODO: move to NixOS official repo when merged
    "${builtins.fetchGit { url = "https://github.com/cgrohs27/nixos-hardware.git"; rev = "64bb927d282e67f9b37be2b5c1bd8ce3b73178d2"; }}/asus/zephyrus/ga403"
  ];

  # TODO: remove workaround for nvidia build failure on linux 6.13 after it's fixed
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "570.86.16"; # use new 570 drivers
    sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
    openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
    settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
    usePersistenced = false;
  };

  my.bundle.desktop.enable = true;

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
