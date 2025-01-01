{ ... }:
{
  programs.zellij = {
    enable = true;
    settings = {
      theme = "catppuccin-macchiato";

      on_force_close = "quit";
      pane_frames = false;
      default_mode = "locked";
      copy_on_select = false;
      ui.pane_frames.hide_session_name = true;

    };
  };
}
