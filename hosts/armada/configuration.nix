{ lib, pkgs, ... }:
{
  imports = [
    # ./services.nix
    ../../nixos
    ../../nixos/modules/oracle-cloud.nix
  ];

  my.bundle.default.enable = true;
  my.networking.enable = false;
  my.oracleCloud.enable = true;
  my.ssh.enable = true;

  networking = {
    hostName = "armada";
    domain = "vypxl.io";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      rejectPackets = true;
    };
  };

  time.timeZone = "Europe/Zurich";

  environment.systemPackages = with pkgs; [
    btop
    curl
    dig
    fzf
    git
    htop
    inetutils
    jq
    ripgrep
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  system.stateVersion = "25.11";
}
