{ config, lib, ... }:
let
  cfg = config.my;
  session = "hyprland-uwsm";
  username = "thomas";
in
{
  options.my = with lib; {
    gdm.enable = mkEnableOption "gdm";
    gdm.autologin = mkEnableOption "Auto Login";
  };

  config = lib.mkIf cfg.gdm.enable {

    security.pam.services.login.enableGnomeKeyring = true;
    services.displayManager = {
      autoLogin = lib.mkIf cfg.gdm.autologin {
        enable = true;
        user = username;
      };

      defaultSession = session;
    };

    services.xserver.displayManager = {
      gdm = {
        enable = true;
        banner = "Welcome to NixOS!";
        autoSuspend = false;
        wayland = true;
      };
    };

    # see https://nixos.wiki/wiki/GNOME#automatic-login
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
  };
}
