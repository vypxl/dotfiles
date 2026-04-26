{ lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    # ./services.nix
    ../../nixos
  ];
  
  my.bundle.default.enable = true;
  my.oracleCloud.enable = true;
  my.ssh.enable = true;

  networking.hostName = "armada";
  networking.domain = "vypxl.io";
  time.timeZone = "Europe/Zurich";

  networking.firewall.enable = true;

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

  system.stateVersion = "25.11";
}
