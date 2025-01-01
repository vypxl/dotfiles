{ config, pkgs, ... }:
with import ../src/util.nix config;
{
  home.packages = with pkgs; [
    brightnessctl
    blueman
    networkmanagerapplet
    seafile-client
    hyprpolkitagent
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = read_dotfile "hypr/hyprland.conf";
    systemd.enable = false; # Conflict with uwsm nixos
    # systemd.variables = [ "--all" ];
    xwayland.enable = true;
  };
  xdg.configFile."hypr/scripts" = dotfile_dir "hypr/scripts";

  home.sessionVariables.NIXOS_OZONE_WL = 1;

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = true;
      preload = [ "~/.config/hypr/wallpaper" ];
      wallpaper = [ ", ~/.config/hypr/wallpaper" ];
    };
  };

  programs.hyprlock.enable = true;
  xdg.configFile."hypr/hyprlock.conf".source = dotfile "hypr/hyprlock.conf";
  xdg.configFile."hypr/macchiato.conf".source = dotfile "hypr/macchiato.conf";

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        {
          timeout = 150; # 2.5min.
          on-timeout = "brightnessctl -s set 5"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r"; # monitor backlight restore.
        }

        # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
        {
          timeout = 150; # 2.5min.
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
          on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
        }

        # {
        #   timeout = 300; # 5min
        #   on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        # }

        # {
        #   timeout = 330; # 5.5min
        #   on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
        #   on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
        # }

        # {
        #   timeout = 1800; # 30min
        #   on-timeout = "systemctl suspend"; # suspend pc
        # }
      ];
    };
  };
}
