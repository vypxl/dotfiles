{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    bluetooth.enable = mkEnableOption "bluetooth";
  };

  config = lib.mkIf cfg.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;
  };
}
