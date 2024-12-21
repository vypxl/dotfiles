{ config, pkgs, ... }:
with import ../src/util.nix config;
{
  home.packages = with pkgs; [
    hyprpolkitagent
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = read_dotfile "hypr/hyprland.conf";
    systemd.enable = false; # Conflict with uwsm nixos
    systemd.variables = [ "--all" ];
    xwayland.enable = true;
  };
  xdg.configFile."hypr/scripts" = dotfile_dir "hypr/scripts";

  home.sessionVariables.NIXOS_OZONE_WL = 1;
}
