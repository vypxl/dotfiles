{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    swapfile.enable = mkEnableOption "swapfile";
  };

  config = lib.mkIf cfg.swapfile.enable {
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 16; # 16mb, only used to rescue out of memory problems
        randomEncryption.enable = true;
      }
    ];
  };
}
