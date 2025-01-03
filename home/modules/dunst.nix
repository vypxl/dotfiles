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
    dunst.enable = mkEnableOption "dunst";
  };

  config = lib.mkIf cfg.dunst.enable {
    services.dunst = {
      enable = true;

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };

      settings = {
        experimental = {
          per_monitor_dpi = false;
        };
        global = {
          alignment = "left";
          always_run_script = true;
          browser = "/usr/bin/env xdg-open";
          class = "Dunst";
          corner_radius = 8;
          ellipsize = "middle";
          enable_recursive_icon_lookup = true;
          follow = "none";
          font = "Fira Code Nerd Font 13";
          force_xinerama = false;
          force_xwayland = false;
          format = "<span color='#50fa7b'><b><i>[ %a ]</i></b></span>\\n\\n<b> - %s - </b>\\n%b";
          frame_color = "#8be9fd";
          frame_width = 3;
          gap_size = 0;
          height = 800;
          hide_duplicate_count = false;
          history_length = 20;
          horizontal_padding = 8;
          icon_position = "left";
          ignore_dbusclose = false;
          ignore_newline = "no";
          indicate_hidden = "yes";
          line_height = 0;
          markup = "full";
          max_icon_size = 64;
          min_icon_size = 32;
          monitor = 0;
          mouse_left_click = "do_action";
          mouse_middle_click = "do_action, close_current";
          mouse_right_click = "close_current";
          notification_limit = 0;
          offset = "12x12";
          origin = "top-right";
          padding = 8;
          progress_bar = false;
          progress_bar_frame_width = 1;
          progress_bar_height = 10;
          progress_bar_max_width = 300;
          progress_bar_min_width = 150;
          scale = 0;
          separator_color = "frame";
          separator_height = 2;
          show_age_threshold = 60;
          show_indicators = "yes";
          sort = "yes";
          stack_duplicates = true;
          sticky_history = "yes";
          text_icon_padding = 0;
          title = "Dunst";
          transparency = 15;
          vertical_alignment = "center";
          width = "(250, 500)";
        };
        urgency_critical = {
          background = "#282a36";
          foreground = "#ff5555";
          frame_color = "#ff5555";
          timeout = 0;
        };
        urgency_low = {
          background = "#282a36";
          foreground = "#f8f8f2";
          frame_color = "#6272a4";
          timeout = 10;
        };
        urgency_normal = {
          background = "#282a36";
          foreground = "#f8f8f2";
          timeout = 10;
        };

      };
    };
  };
}
