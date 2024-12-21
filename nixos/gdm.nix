{ pkgs, ... }:

let
  session = "hyprland-uwsm";
  username = "thomas";
in

{
  security.pam.services.login.enableGnomeKeyring = true;
  services.displayManager = {
    autoLogin = {
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
}
