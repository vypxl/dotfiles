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

    oidc = {
      enable = mkEnableOption "OIDC authentication for the Kubernetes API server";
      issuerUrl = mkOption {
        type = types.str;
        description = "OIDC issuer URL trusted by the Kubernetes API server.";
      };
      clientId = mkOption {
        type = types.str;
        description = "OIDC client ID expected in token audience claims.";
      };
      usernameClaim = mkOption {
        type = types.str;
        default = "email";
        description = "OIDC claim to use as the Kubernetes username.";
      };
      usernamePrefix = mkOption {
        type = types.str;
        default = "oidc:";
        description = "Prefix added to OIDC usernames.";
      };
      groupsClaim = mkOption {
        type = types.str;
        default = "groups";
        description = "OIDC claim to use as Kubernetes groups.";
      };
      groupsPrefix = mkOption {
        type = types.str;
        default = "oidc:";
        description = "Prefix added to OIDC groups.";
      };
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
      ]
      + lib.optionalString cfg.oidc.enable (
        " "
        + toString [
          "--kube-apiserver-arg=oidc-issuer-url=${cfg.oidc.issuerUrl}"
          "--kube-apiserver-arg=oidc-client-id=${cfg.oidc.clientId}"
          "--kube-apiserver-arg=oidc-username-claim=${cfg.oidc.usernameClaim}"
          "--kube-apiserver-arg=oidc-username-prefix=${cfg.oidc.usernamePrefix}"
          "--kube-apiserver-arg=oidc-groups-claim=${cfg.oidc.groupsClaim}"
          "--kube-apiserver-arg=oidc-groups-prefix=${cfg.oidc.groupsPrefix}"
        ]
      );
    };

    # ── Networking ──────────────────────────────────────────────
    # K3s sets this at runtime, but a NetworkManager or systemd-sysctl
    # reload can reset it.  Pin it in the NixOS sysctl config so pod
    # traffic always survives.
    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

    # ── Firewall ────────────────────────────────────────────────
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 6443 ];
      trustedInterfaces = [
        "cni0"
        "flannel.1"
      ];
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
    programs.fish.shellInit = ''
      set -gx KUBECONFIG "/etc/rancher/k3s/k3s.yaml"
    '';

    # ── Flux bootstrap service ──────────────────────────────────
    # Runs once after k3s is ready. Idempotent — safe to re-run on
    # every boot; bootstrap is a no-op if Flux is already installed.
    systemd.services.flux-bootstrap = lib.mkIf cfg.flux.enable {
      description = "Bootstrap FluxCD into k3s";
      wantedBy = [ "multi-user.target" ];
      after = [ "k3s.service" ];
      requires = [ "k3s.service" ];
      path = with pkgs; [
        fluxcd
        kubectl
        git
        ssh-to-age
      ];
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

        # Derive the age key from the SSH host key (same as sops-nix does)
        echo "Creating SOPS age secret..."
        ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > /tmp/age.key
        kubectl -n flux-system create secret generic sops-age \
          --from-file=age.agekey=/tmp/age.key \
          --dry-run=client -o yaml | kubectl apply -f -
        rm /tmp/age.key

        echo "Flux bootstrap complete."
      '';
    };
  };
}
