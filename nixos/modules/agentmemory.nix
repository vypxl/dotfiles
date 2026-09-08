{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.agentmemory;

  dockerCompat = pkgs.runCommand "podman-docker-compat" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.podman}/bin/podman $out/bin/docker
  '';
in
{
  options.my.agentmemory = {
    enable = lib.mkEnableOption "agentmemory";

    user = lib.mkOption {
      type = lib.types.str;
      default = "thomas";
      description = "User running agentmemory.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user}.linger = true;

    systemd.user.services.agentmemory = {
      description = "agentmemory daemon";
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      unitConfig.ConditionUser = cfg.user;
      path = with pkgs; [
        bash
        curl
        gnutar
        gzip
        nodejs
        podman
        podman-compose
        dockerCompat
        which
        "/run/wrappers"
      ];
      serviceConfig = {
        ExecStart = "${pkgs.nodejs}/bin/npx -y @agentmemory/agentmemory";
        Restart = "on-failure";
        RestartSec = 5;
        Environment = [ "AGENTMEMORY_USE_DOCKER=1" ];
      };
    };
  };
}
