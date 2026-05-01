{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    oracleCloud.enable = mkEnableOption "oracle cloud";
  };

  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  config = lib.mkIf cfg.oracleCloud.enable {
    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "virtio_pci"
      "virtio_scsi"
      "usbhid"
    ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelParams = [ "net.ifnames=0" ];

    security.sudo.wheelNeedsPassword = false;

    disko.devices = {
      disk.disk0 = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            nixos = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
