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
    ssh.enable = mkEnableOption "ssh access";
  };

  config = lib.mkIf cfg.ssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
    };
    
    users.users.thomas.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGdcyJt7QCpshfGWnjWsomJ3EbZI3k/xuWVdcpOP57TL thomas@vypxl.io"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPy8CJvxjK1mPCHym+pBVoKeNNYRP9cfRY2k5yF7Io9s thomas@nunu.ai"
    ];

    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
