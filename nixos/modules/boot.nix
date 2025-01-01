{ ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # needed for auto-unlock of gnome keyring
  # in gdm with luks pw
  # and for plymouth
  boot.initrd.systemd.enable = true;
  
  # in case the ESP has size problems, this can limit
  # the amout of different kernels/initframs that are put there
  # beware this limits rollback options
  # boot.loader.systemd-boot.configurationLimit = 1;
}
