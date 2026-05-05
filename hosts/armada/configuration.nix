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
  };

  networking = {
    hostName = "armada";
    domain = "lab.vypxl.io";
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

  my.localDockerImages.images.firecrawl-nuq = {
    repo = "https://github.com/firecrawl/firecrawl.git";
    branch = "main";
    context = "apps/nuq-postgres";
    image = "localhost/nuq-postgres:latest";
    stateDir = "/var/lib/firecrawl-nuq-postgres";
    schedule = "daily";
    importToK3s = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  system.stateVersion = "25.11";
}
