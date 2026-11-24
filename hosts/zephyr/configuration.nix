{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos
    # TODO: move to NixOS official repo when merged
    "${
      builtins.fetchGit {
        url = "https://github.com/vypxl/nixos-hardware.git";
        rev = "199d1f7a8d9fd55f26dc9659549a8c0a8f5a8a81";
      }
    }/asus/zephyrus/ga403"
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;

  # Avoid extra encryption queues on the NVMe SSD.
  boot.initrd.luks.devices."luks-86a0f0c7-80ae-4439-b070-341dbd247bf3".bypassWorkqueues = true;

  # Prevent WD PC SN5000S (15b7:5036) NVMe controller timeouts/resets on deep power-state transitions.
  boot.kernelParams = [
    "nvme_core.default_ps_max_latency_us=0"
  ];
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x15b7", ATTR{device}=="0x5036", ATTR{link/l1_2_aspm}="0"
  '';

  my.bundle.desktop.enable = true;

  # Kill user applications under sustained memory pressure before the desktop freezes.
  systemd.oomd.enable = true;
  systemd.user.slices.app.sliceConfig = {
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "60%";
  };
  systemd.user.slices.background.sliceConfig = {
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "60%";
  };
  # Prefer the compositor and session services when applications saturate the CPU.
  systemd.user.slices.session.sliceConfig.CPUWeight = 200;

  my.niri.enable = true;
  my.hyprland.enable = false;

  my.boot.splash = true;
  my.boot.limit-entries = 2;
  my.gdm.autologin = true;
  my.networking.dns.enable = false;
  my.gaming.enable = true;

  virtualisation.containers.containersConf.settings.network.default_rootless_network_cmd = "slirp4netns";

  environment.systemPackages = with pkgs; [
    _1password-gui
    _1password-cli
    slirp4netns
    unstable.stretchly
  ];

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    brlaser
    mfcl2700dnlpr
    mfcl2700dncupswrapper
  ];

  networking.hostName = "zephyr";
  time.timeZone = "Europe/Zurich";

  fileSystems = {
    "/".options = [ "compress=zstd" ];
  };

  system.stateVersion = "24.11";
}
