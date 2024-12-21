{ ... }:
{
  programs.kitty = {
    enable = true;
    font.name = "Fira Code";
    font.size = 11.5;
    themeFile = "Catppuccin-Macchiato";

    settings = {
      # Remote control and socket settings
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";

      # Clipboard control settings
      clipboard_control = "write-clipboard read-clipboard write-primary read-primary";

      # Control settings
      scrollback_lines = 10000;
      wheel_scroll_multiplier = 3;
      touch_scroll_multiplier = 3;

      # Bell settings
      enable_audio_bell = false;
      visual_bell_duration = 0;
      window_alert_on_bell = false;
      bell_on_tab = false;

      # Window settings
      remember_window_size = true;
      window_padding_width = 15;

      # Tab settings
      tab_bar_edge = "top";
      tab_bar_style = "separator";
      tab_title_template = "[{index}] {title}";

      # Session settings
      # startup_session = "tmux.sess";

      # Layout settings
      enabled_layouts = "tall:bias=70;full_size=1;mirrored=true";

      # Background opacity setting
      background_opacity = 0.87;
    };
  };

  xdg.configFile."kitty/tmux.sess".text = ''
    # launch sh -c 'if tmux has -t home; then tmux; else tmux new -s home; fi'
  '';
}
