{ config, pkgs, ... }:
with import ../src/util.nix config;
{
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      # tmuxPlugins.sensible # included automatically by home-manager
      unstable.tmuxPlugins.tmux-powerline
    ];

    extraConfig = ''
      # prefix
      unbind C-b
      set-option -g prefix C-space
      bind-key C-space send-prefix

      # better binds
      bind v split-window -v
      bind h split-window -h

      unbind '"'
      unbind %

      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      bind -n C-M-Right select-window -n
      bind -n C-M-Left select-window -p

      bind -n C-M-Up switch-client -n
      bind -n C-M-Down switch-client -p

      bind -n M-m resize-pane -Z

      bind -n C-t new-window -c "#{pane_current_path}"
      bind -n C-n command-prompt -p "New session name:" "new-session -A -s '%%'"

      # reload
      bind r display-message "Reloading tmux config..." \; source-file ~/.config/tmux/tmux.conf

      # misc
      set -g mouse on
      set-option -g allow-rename off
      setw -g mode-keys vi

      # no bell
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # functions

      # some floating pane shortcuts
      bind g display-popup -EE -b rounded -w 90% -h 90% -d "#{pane_current_path}" lazygit
      bind y display-popup -E -b rounded -w 90% -h 90% lazygit -w ~ -g ~/.local/share/yadm/repo.git

      # make ctrl-\ toggle the scratch session in a floating pane
      bind -n C-\\ if-shell -F "#{==:#{session_name},scratch}" "detach-client" "display-popup -E -b rounded -w 90% -h 90% -d \"#{pane_current_path}\" tmux new -A -s scratch"
    '';
  };

  xdg.configFile."tmux-powerline" = dotfile_dir "tmux-powerline";
}
