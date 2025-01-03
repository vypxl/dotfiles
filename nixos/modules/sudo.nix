{ config, lib, pkgs, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    sudo.enable = mkEnableOption "sudo";
  };

  config = lib.mkIf cfg.sudo.enable {
    security.sudo = {
      enable = true;
      extraRules = [
        {
          commands = [
            {
              command = "${pkgs.systemd}/bin/reboot";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/nixos-rebuild";
              options = [ "NOPASSWD" ];
            }
          ];
          groups = [ "wheel" ];
        }
      ];
    };
  };
}
