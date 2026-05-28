{
  config,
  lib,
  pkgs,
  ...
}:
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
  my.boot.splash = false;
  my.k3s = {
    enable = true;
    oidc = {
      enable = true;
      issuerUrl = "https://id.lab.vypxl.io";
      clientId = "kubernetes";
    };
    flux = {
      enable = true;
      tokenFile = config.sops.secrets.flux-github-token.path;
      path = "hosts/armada/cluster/flux";
    };
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.flux-github-token = { };

    # nix CLI parses /etc/nix/nix.conf as the invoking user; !include fails silently
    # if the file is root-only (0400). Wheel must be able to read this fragment.
    templates."nix-access-tokens.conf" = {
      content = "access-tokens = github.com=${config.sops.placeholder."flux-github-token"}\n";
      mode = "0440";
      group = config.users.groups.wheel.name;
      restartUnits = [ "nix-daemon.service" ];
    };
  };

  nix.extraOptions = ''
    !include ${config.sops.templates."nix-access-tokens.conf".path}
  '';

  networking = {
    hostName = "armada";
    domain = "lab.vypxl.io";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ 25565 ];
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

  my.localDockerImages.images.composer-api-responses-proxy = {
    repo = "https://github.com/standardagents/composer-api.git";
    branch = "main";
    image = "localhost/composer-api-responses-proxy:latest";
    dockerfileText = ''
      FROM node:22-alpine

      WORKDIR /app

      ENV NODE_ENV=production
      ENV CURSOR_SDK_PROXY_HOST=0.0.0.0
      ENV CURSOR_SDK_PROXY_PORT=8791

      COPY package.json package-lock.json ./
      RUN npm ci --omit=dev

      COPY scripts/cursor-sdk-responses-proxy.mjs ./scripts/cursor-sdk-responses-proxy.mjs

      EXPOSE 8791

      USER node

      CMD ["node", "scripts/cursor-sdk-responses-proxy.mjs"]
    '';
    baseImage = "docker.io/library/node:22-alpine";
    schedule = "daily";
    importToK3s = true;
    restartKube = [
      { resource = "statefulset/composer-api"; }
    ];
  };

  my.localDockerImages.images.firecrawl-nuq = {
    repo = "https://github.com/firecrawl/firecrawl.git";
    branch = "main";
    context = "apps/nuq-postgres";
    image = "localhost/nuq-postgres:latest";
    schedule = "daily";
    importToK3s = true;
  };

  my.localDockerImages.images.hermes = {
    image = "localhost/hermes-agent:latest";
    dockerfileText = ''
      FROM docker.io/nousresearch/hermes-agent:latest

      # s6-overlay images must finish as root: /init chowns /opt/data and
      # supervised services drop to the hermes user via s6-setuidgid.
      # Do not end with USER hermes — that breaks K8s pods with
      # allowPrivilegeEscalation: false (see upstream Dockerfile comments).
      USER root
      RUN apt-get update \
        && apt-get install -y --no-install-recommends vim \
        && rm -rf /var/lib/apt/lists/*
      RUN chsh -s /bin/bash hermes

      WORKDIR /opt/hermes
      RUN uv pip install --no-cache-dir -e '.[hindsight]' \
        && chown -R hermes:hermes /opt/hermes/.venv
    '';
    baseImage = "docker.io/nousresearch/hermes-agent:latest";
    schedule = "daily";
    importToK3s = true;
    restartKube = [
      { resource = "statefulset/hermes"; }
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  system.stateVersion = "25.11";
}
