{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my;
  isX86Linux = pkgs.stdenv.hostPlatform.isx86_64;
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

    hardware.keyboard.qmk.enable = lib.mkIf isX86Linux true;
    hardware.keyboard.zsa.enable = lib.mkIf isX86Linux true;
    services.udev.packages = lib.optionals isX86Linux [ pkgs.via ];
    services.gvfs.enable = true; # Support MTP file systems (e.g. Android file transfer mode)

    environment.systemPackages =
      with pkgs;
      [
        git
        vim
        wget

        ntfs3g
      ]
      ++ lib.optionals isX86Linux [
        qmk-udev-rules
        zsa-udev-rules
        via
        steam-run-free
      ];

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libgcc # libstdc++
      ];
    };

    programs.appimage = lib.mkIf isX86Linux {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.icu
          pkgs.libxcrypt-legacy
          pkgs.zstd
        ];
      };
    };
  };
}
