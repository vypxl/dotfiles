{ ... }:
{
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16; # 16mb, only used to rescue out of memory problems
      randomEncryption.enable = true;
    }
  ];
}
