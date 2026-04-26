{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    docker.enable = mkEnableOption "docker";
    docker.backend = mkOption {
      type = types.enum [
        "podman"
        "docker"
      ];
      default = "podman";
      description = "Container backend to expose for Docker-compatible workloads.";
    };
  };

  config = lib.mkIf cfg.docker.enable {
    virtualisation = lib.mkMerge [
      {
        containers.enable = true;
      }
      (lib.mkIf (cfg.docker.backend == "podman") {
        podman = {
          enable = true;
          dockerCompat = true;
          dockerSocket.enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      })
      (lib.mkIf (cfg.docker.backend == "docker") {
        docker = {
          enable = true;
          liveRestore = false;
        };
      })
    ];

    users.users.thomas.extraGroups = [
      (if cfg.docker.backend == "podman" then "podman" else "docker")
    ];

    environment.systemPackages =
      with pkgs;
      lib.mkMerge [
        (lib.mkIf (cfg.docker.backend == "podman") [
          podman-compose
          podman-tui
        ])
        (lib.mkIf (cfg.docker.backend == "docker") [ docker-compose ])
      ];
  };
}
