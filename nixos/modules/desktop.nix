{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my;
  desktop-enabled = cfg.hyprland.enable || cfg.niri.enable;
in
{
  options.my = with lib; {
    hyprland.enable = mkEnableOption "hyprland";
    niri.enable = mkEnableOption "niri";
  };

  config = lib.mkIf desktop-enabled {
    programs.hyprland = lib.mkIf cfg.hyprland.enable {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    programs.niri = lib.mkIf cfg.niri.enable {
      enable = true;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code
    ];

    services.playerctld.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;

    # For some reason, gparted needs to be a system package
    # Otherwise we can't run it via polkit
    environment.systemPackages = [
      pkgs.gparted
    ]
    # xwayland for niri
    ++ (if cfg.niri.enable then [ pkgs.xwayland-satellite ] else [ ]);
  };
}
