{ config, lib, pkgs, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    docker.enable = mkEnableOption "docker";
  };

  config = lib.mkIf cfg.docker.enable {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    environment.systemPackages = with pkgs; [ podman-compose podman-tui ];
  };
}
