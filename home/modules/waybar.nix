{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    waybar.enable = mkEnableOption "waybar";
  };

  config = lib.mkIf cfg.waybar.enable {
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          backlight = {
            device = "intel_backlight";
            format = "{percent}% {icon}";
            format-icons = [
              ""
              ""
            ];
            tooltip = true;
            tooltip-format = "{percent}%";
          };
          battery = {
            format = "{capacity}% {icon}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            on-update = "hypr_check_battery";
            states = {
              critical = 10;
              warning = 20;
            };
            tooltip-format = "{timeTo}";
          };
          bluetooth = {
            format = " {status}";
            format-connected = " {device_alias}";
            format-connected-battery = " {device_alias} {device_battery_percentage}%";
            on-click = "blueman-manager";
            tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
            tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          };
          clock = {
            format = "{:%a %d.%m %H:%M}";
            format-alt = "{:%m/%d/%y %H:%M}";
          };
          "custom/power" = {
            format = "";
            on-click = "hypr_powermenu";
          };
          height = 30;
          "hyprland/window" = {
            format = "{}";
            separate-outputs = true;
          };
          "hyprland/workspaces" = {
            format = "{icon} {name}";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              active = "";
              default = "";
              urgent = "";
            };
            on-click = "activate";
            sort-by-number = true;
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          layer = "top";
          modules-center = [ ];
          modules-left = [
            "custom/power"
            "user"
            "hyprland/workspaces"
          ];
          modules-right = [
            "mpris"
            "backlight"
            "pulseaudio"
            "idle_inhibitor"
            "tray"
            "custom/kdeconnect"
            "battery"
            "clock"
          ];
          mpris = {
            artist-len = 16;
            format = "{player_icon} {status_icon} {artist} - <i>{title}</i>";
            interval = 1;
            player-icons = {
              brave = "";
              chromium = "";
              default = "🎵";
              firefox = "";
              spotify = "";
              vlc = "󰕼";
            };
            status-icons = {
              paused = "⏸";
            };
            title-len = 24;
          };
          network = {
            format = "{ifname}";
            format-disconnected = "睊";
            format-ethernet = "";
            format-wifi = "";
            tooltip-format = "{ifname} via {gwaddr} ";
            tooltip-format-disconnected = "Disconnected";
            tooltip-format-ethernet = "{ifname} ";
            tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          };
          pulseaudio = {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-icons = {
              default = [
                ""
                ""
              ];
            };
            format-muted = "";
            on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
            on-click-right = "pavucontrol";
            scroll-step = 1;
          };
          "sway/window" = {
            max-length = 50;
          };
          tray = {
            icon-size = 21;
            spacing = 10;
          };
          user = {
            format = "λ vypxl (up {work_d}d {work_H}h {work_M}m)";
          };
        };
      };

      style = ''
        * {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: FontAwesome, Fira Code, Roboto, Helvetica, Arial, sans-serif;
          font-size: 16px;
        }
        /* drac-bgd: #282a36; */
        /* drac-cur: #44475a; */
        /* drac-fgd: #f8f8f2; */
        /* drac-cmt: #6272a4; */
        /* drac-cya: #8be9fd; */
        /* drac-grn: #50fa7b; */
        /* drac-ora: #ffb86c; */
        /* drac-pnk: #ff79c6; */
        /* drac-pur: #bd93f9; */
        /* drac-red: #ff5555; */
        /* drac-yel: #f1fa8c; */

        window#waybar {
          background-color: transparent;
          color: #f8f8f2;
          transition-property: background-color;
          transition-duration: 0.5s;
          margin: 100px;
        }

        window#waybar.hidden {
          opacity: 0.2;
        }

        button {
          /* Use box-shadow instead of border so the text isn't offset */
          box-shadow: inset 0 -3px transparent;
          /* Avoid rounded borders under each button name */
          border: none;
          border-radius: 0;
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        button:hover {
          background: inherit;
          box-shadow: inset 0 -3px #f8f8f2;
        }

        #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #f8f8f2;
        }

        #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
        }

        #workspaces button.focused {
          background-color: #64727d;
          box-shadow: inset 0 -3px #f8f8f2;
        }

        #workspaces button.urgent {
          background-color: #eb4d4b;
        }

        #mode {
          background-color: #64727d;
          border-bottom: 3px solid #f8f8f2;
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #disk,
        #temperature,
        #backlight,
        #network,
        #pulseaudio,
        #wireplumber,
        #custom-media,
        #tray,
        #mode,
        #idle_inhibitor,
        #scratchpad,
        #mpd,
        #mpris,
        #user,
        #workspaces,
        #window,
        #custom-power,
        #custom-kdeconnect {
          padding: 2px 14px 2px 10px;
          margin: 4px 5px 0px 4px;
          color: #f8f8f2;
          background-color: rgba(40, 42, 54, 0.8);
          border-radius: 16px;
        }

        #battery.charging,
        #battery.plugged {
          color: #282a36;
          background-color: rgba(80, 250, 122, 0.8);
        }

        #battery.warning {
          color: #282a38;
          background-color: #ffb86c;
        }

        @keyframes blink {
          to {
            background-color: #f8f8f2;
            color: #282a36;
          }
        }

        #battery.critical:not(.charging) {
          background-color: #ff5555;
          color: #282a36;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        label:focus {
          background-color: #000000;
        }

        #backlight,
        #pulseaudio {
          background-color: rgba(98, 114, 164, 0.7);
        }

        #pulseaudio.muted {
          background-color: rgba(68, 71, 90, 0.7);
          color: #f8f8f2;
        }

        #tray {
          background-color: transparent;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #ff79c6;
        }

        #idle_inhibitor {
          background-color: rgba(40, 42, 54, 0.7);
        }

        #idle_inhibitor.activated {
          background-color: rgba(107, 234, 253, 0.85);
          color: #282a36;
        }
      '';
    };
  };
}
