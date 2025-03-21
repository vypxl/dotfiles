{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    base.enable = mkEnableOption "base";
  };

  config = lib.mkIf cfg.base.enable {
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    hardware.keyboard.qmk.enable = true;
    hardware.keyboard.zsa.enable = true;
    services.udev.packages = [ pkgs.via ];

    environment.systemPackages = with pkgs; [
      git
      vim
      wget
      comma

      qmk-udev-rules
      zsa-udev-rules
      via
    ];

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libgcc # libstdc++
      ];
    };
  };
}
