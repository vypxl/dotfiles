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
    oracleCloud.enable = mkEnableOption "base";
  };

  config = lib.mkIf cfg.oracleCloud.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelParams = [ "net.ifnames=0" ];

    networking = {
      useDHCP = true;
      interfaces.eth0 = {
        useDHCP = true;
      };
      # Note: you also need to configure open ports in the Oracle Cloud web interface
      # (Virtual Cloud Network -> Security Lists -> Ingress Rules)
      firewall = {
        logRefusedConnections = false;
        rejectPackets = true;
      };
    };
  };
}
