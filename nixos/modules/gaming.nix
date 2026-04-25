{ config, lib, pkgs, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    gaming.enable = mkEnableOption "gaming";
  };

  config = lib.mkIf cfg.gaming.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      protonup-qt
      prismlauncher # minecraft
    ];

    networking.firewall.allowedTCPPorts = [ 25565 ];
  };
}
