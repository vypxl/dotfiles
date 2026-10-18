{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    android.enable = mkEnableOption "android";
  };

  config = lib.mkIf cfg.android.enable {
    users.users.thomas.extraGroups = [
      "adbusers"
      "kvm"
    ];
  };
}
