{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    swap.enable = mkEnableOption "Swap";
  };

  config = lib.mkIf cfg.swap.enable {
    zramSwap = {
      enable = true;
      memoryPercent = 25;
    };

    boot.kernel.sysctl = {
      "vm.swappiness" = 5;
    };
  };
}
