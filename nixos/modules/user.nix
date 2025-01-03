{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    user.enable = mkEnableOption "user";
  };

  config = lib.mkIf cfg.user.enable {
    users.users.thomas = {
      isNormalUser = true;
      description = "Thomas";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };
}
