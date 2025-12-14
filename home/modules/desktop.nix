{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
let
  cfg = config.my;
  desktop-enabled = cfg.hyprland.enable || cfg.niri.enable;
  hyprland-config = lib.mkIf cfg.hyprland.enable {
    my.dunst.enable = true;
    my.fuzzel.enable = true;
    my.waybar.enable = true;
    my.wlogout.enable = true;

    home.packages = with pkgs; [
      hyprpicker
      hyprshot
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ../../config/hypr/hyprland.conf;
      systemd.enable = false; # Conflict with uwsm nixos
      # systemd.variables = [ "--all" ];
      xwayland.enable = true;
    };

    xdg.configFile."hypr/hyprland-custom.conf".text =
      if hostname == "zephyr" then
        ''
          monitor=eDP-1,preferred,auto,1.6666667
          monitor=DP-10,highres,auto,auto
          monitor=DP-11,highres,auto,auto
        ''
      else
        "";

    services.hyprpaper = {
      enable = true;
      settings = {
        splash = true;
        preload = [ "~/.config/hypr/wallpaper" ];
        wallpaper = [ ", ~/.config/hypr/wallpaper" ];
      };
    };

    programs.hyprlock.enable = true;
    my.dotfile."hypr/hyprlock.conf".enable = true;
    my.dotfile."hypr/macchiato.conf".enable = true;

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
            on-timeout = "brightnessctl -sd amdgpu_bl1 set 5"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "brightnessctl -rd amdgpu_bl1"; # monitor backlight restore.
          }

          # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
          # {
          #   timeout = 150; # 2.5min.
          #   on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
          #   on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
          # }

          {
            timeout = 270; # 4.5min (+ 30s grace period of hyprlock)
            on-timeout = "hyprlock"; # lock screen when timeout has passed
          }

          {
            timeout = 600; # 10min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
          }

          # {
          #   timeout = 1800; # 30min
          #   on-timeout = "systemctl suspend"; # suspend pc
          # }
        ];
      };
    };
  };
  niri-config = lib.mkIf cfg.niri.enable {
    my.dotfile.niri.mut = true;
    my.dotfile.DankMaterialShell.mut = true;

    home.packages = with pkgs; [
      unstable.dsearch
    ];

    programs.dankMaterialShell = {
      enable = true;

      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged = true; # Auto-restart dms.service when dankMaterialShell changes
      };

      # Core features
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      # enableClipboard = true; # Clipboard history manager
      enableVPN = true; # VPN management widget
      # enableBrightnessControl = true; # Backlight/brightness controls
      # enableColorPicker = true; # Color picker tool
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = true; # Calendar integration (khal)
      # enableSystemSound = false; # System sound effects
    };
  };

  common-config = lib.mkIf desktop-enabled {
    home.packages = with pkgs; [
      brightnessctl
      blueman
      networkmanagerapplet
      seafile-client
      soteria
    ];

    # Cursor theme
    home.file.".icons/default".source =
      "${pkgs.catppuccin-cursors.macchiatoSky}/share/icons/catppuccin-macchiato-sky-cursors"; # "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";

    # face
    home.file.".face".source = ../src/face.png;

    # auto mount disks
    services.udiskie.enable = true;
    # bt media control
    services.mpris-proxy.enable = true;

    # dark theme
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
    };
  };
in
{
  options.my = with lib; {
    hyprland.enable = mkEnableOption "hyprland";
    niri.enable = mkEnableOption "niri";
  };

  config = lib.mkMerge [
    common-config
    hyprland-config
    niri-config
  ];
}
