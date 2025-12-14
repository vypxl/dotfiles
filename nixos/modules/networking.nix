{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.my.networking;
in
{
  options.my.networking = {
    enable = mkEnableOption "networking";
    dns.enable = mkEnableOption "Enable custom DNS";
    dns.servers = mkOption {
      type = types.listOf types.str;
      default = [ "mullvad-extend-doh" ];
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
    # services.resolved.enable = true; # for .local domains
    services.avahi = {
      enable = true;
      nssmdns4 = true;
    };

    # wireguard with networkmanager
    networking.firewall.checkReversePath = false;

    networking.firewall = {
      enable = true;
      # Do not timeout, just reject
      rejectPackets = true;
      # Allow local network access
      extraCommands = ''
        iptables -A nixos-fw -p tcp --source 192.168.0.0/16 --dport 8000:8000 -j nixos-fw-accept
      '';
      extraStopCommands = ''
        iptables -D nixos-fw -p tcp --source 192.168.0.0/16 --dport 8000:8000 nixos-fw-accept || true
      '';
    };

    # custom dns
    networking.nameservers = mkIf cfg.dns.enable [
      "127.0.0.1"
      "::1"
    ];
    networking.networkmanager.dns = mkIf cfg.dns.enable "none";

    services.dnscrypt-proxy = mkIf cfg.dns.enable {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;

        forwarding_rules = pkgs.writeText "forwarding-rules.txt" ''
          lan $DHCP
          local $DHCP
          home $DHCP
          localdomain $DHCP
        '';

        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };

        # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        server_names = cfg.dns.servers;
      };
    };

    systemd.services.dnscrypt-proxy2.serviceConfig = mkIf cfg.dns.enable {
      StateDirectory = "dnscrypt-proxy";
    };
  };
}
