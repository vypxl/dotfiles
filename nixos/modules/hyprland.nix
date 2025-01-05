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
    hyprland.enable = mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      fira-code
      fira-code-symbols
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    services.playerctld.enable = true;
    services.udisks2.enable = true;

    # For some reason, gparted needs to be a system package
    # Otherwise we can't run it via polkit
    environment.systemPackages = [ pkgs.gparted ];
  };
}
