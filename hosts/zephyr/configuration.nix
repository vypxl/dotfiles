{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos
    # TODO: move to NixOS official repo when merged
    "${builtins.fetchGit { url = "https://github.com/cgrohs27/nixos-hardware.git"; rev = "64bb927d282e67f9b37be2b5c1bd8ce3b73178d2"; }}/asus/zephyrus/ga403"
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_16;
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "580.65.06";
    sha256_64bit = "sha256-BLEIZ69YXnZc+/3POe1fS9ESN1vrqwFy6qGHxqpQJP8=";
    openSha256 = "sha256-BKe6LQ1ZSrHUOSoV6UCksUE0+TIa0WcCHZv4lagfIgA=";
    settingsSha256 = "sha256-9PWmj9qG/Ms8Ol5vLQD3Dlhuw4iaFtVHNC0hSyMCU24=";
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
