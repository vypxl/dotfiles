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
    boot.enable = mkEnableOption "boot";
    boot.limit-entries = mkOption {
      type = types.int;
      default = 5;
      description = ''
        Limit the amount of kernel/initramfs pairs in the ESP.
        This can be useful if the ESP is too small.
        Beware that this limits the amount of rollback options.
      '';
    };
    boot.splash = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable splash screen during boot (uses plymouth).
      '';
    };
  };

  config = lib.mkIf cfg.boot.enable (
    lib.mkMerge [
      {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # needed for auto-unlock of gnome keyring
        # in gdm with luks pw
        # and for plymouth
        boot.initrd.systemd.enable = true;

        boot.loader.systemd-boot.configurationLimit = cfg.boot.limit-entries;
      }

      {
        boot = lib.mkIf cfg.boot.splash {
          plymouth = {
            enable = true;
            # theme = "circle_hud";
            theme = "catppuccin-macchiato";
            themePackages = with pkgs; [
              # By default we would install all themes
              # (adi1090x-plymouth-themes.override {
              #   selected_themes = [ "circle_hud" ];
              # })
              catppuccin-plymouth
            ];
          };
          # Enable "Silent Boot"
          consoleLogLevel = 0;
          initrd.verbose = false;
          kernelParams = [
            "quiet"
            "splash"
            "boot.shell_on_fail"
            "loglevel=3"
            "rd.systemd.show_status=false"
            "rd.udev.log_level=3"
            "udev.log_priority=3"
          ];
          # Hide the OS choice for bootloaders.
          # It's still possible to open the bootloader list by pressing any key
          # It will just not appear on screen unless a key is pressed
          loader.timeout = 0;
        };
      }
    ]
  );
}
