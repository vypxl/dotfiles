{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    docker.enable = mkEnableOption "docker";
  };

  config = lib.mkIf cfg.docker.enable {
    virtualisation.docker.enable = true;
    users.users.thomas.extraGroups = [ "docker" ];
  };
}
