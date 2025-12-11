{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    swap.enable = mkEnableOption "Swap";
  };

  config = lib.mkIf cfg.swap.enable {
    # zramSwap = {
    #   enable = true;
    #   memoryPercent = 33;
    # };

    swapDevices = [{
      device = "/var/lib/swapfile";
      size = 16 * 1024;
      options = [ "discard" ];
    }];

    boot.kernel.sysctl = {
      "vm.swappiness" = 30;
    };

    boot.kernelParams = [
      "zswap.enabled=1" # enables zswap
      "zswap.compressor=zstd" # compression algorithm
      "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use
      "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure
    ];
  };
}

