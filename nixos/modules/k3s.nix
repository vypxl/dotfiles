{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.k3s;
in
{
  options.my.k3s = with lib; {
    enable = mkEnableOption "k3s";
    domain = mkOption {
      type = types.str;
      default = config.networking.domain or config.networking.hostName;
      description = "Domain / TLS SAN to add to the k3s API server certificate.";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to open the Kubernetes API port (6443) in the firewall.";
    };

    flux = {
      enable = mkEnableOption "Flux GitOps bootstrap";
      repo = mkOption {
        type = types.str;
        default = "dotfiles";
        description = "GitHub repository name.";
      };
      owner = mkOption {
        type = types.str;
        default = "vypxl";
        description = "GitHub repository owner.";
      };
      branch = mkOption {
        type = types.str;
        default = "main";
        description = "Git branch to track.";
      };
      path = mkOption {
        type = types.str;
        description = "Path inside the repo where Flux looks for its sync config.";
      };
      tokenFile = mkOption {
        type = types.path;
        description = "Path to a file containing a GitHub PAT (e.g. a sops-nix secret).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # ── K3s server (single-node) ────────────────────────────────
    services.k3s = {
      enable = true;
      role = "server";
      extraFlags = toString [
        "--write-kubeconfig-mode=644" # let non-root users read kubeconfig
        "--tls-san=${cfg.domain}" # allow remote kubectl via domain name
        "--tls-san=${config.networking.hostName}"
      ];
    };

    # ── Firewall ────────────────────────────────────────────────
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 6443 ];
      trustedInterfaces = [ "cni0" "flannel.1" ];
    };

    # ── CLI tools ───────────────────────────────────────────────
    environment.systemPackages = with pkgs; [
      kubectl
      kubernetes-helm
      fluxcd
      k9s
    ];

    # ── Shell convenience ───────────────────────────────────────
    environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

    # ── Flux bootstrap service ──────────────────────────────────
    # Runs once after k3s is ready. Idempotent — safe to re-run on
    # every boot; bootstrap is a no-op if Flux is already installed.
    systemd.services.flux-bootstrap = lib.mkIf cfg.flux.enable {
      description = "Bootstrap FluxCD into k3s";
      wantedBy = [ "multi-user.target" ];
      after = [ "k3s.service" ];
      requires = [ "k3s.service" ];
      path = with pkgs; [ fluxcd kubectl git ];
      environment.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        # Retry — k3s needs a few seconds before the API server accepts requests
        Restart = "on-failure";
        RestartSec = 10;
        StartLimitIntervalSec = 300;
        StartLimitBurst = 10;
      };

      script = ''
        set -euo pipefail

        # Wait for the API server to be reachable
        echo "Waiting for k3s API server..."
        until kubectl get nodes &>/dev/null; do
          sleep 5
        done

        echo "Bootstrapping Flux..."
        GITHUB_TOKEN=$(cat ${cfg.flux.tokenFile})
        export GITHUB_TOKEN

        flux bootstrap github \
          --token-auth \
          --owner=${cfg.flux.owner} \
          --repository=${cfg.flux.repo} \
          --branch=${cfg.flux.branch} \
          --path=${cfg.flux.path} \
          --personal
      '';
    };
  };
}
