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
    gnome-keyring.enable = mkEnableOption "gnome-keyring";
  };

  config = lib.mkIf cfg.gnome-keyring.enable {
    home.packages = [
      pkgs.seahorse
      pkgs.gcr
    ];
    services.gnome-keyring.enable = true;
    programs.fish.shellInit = ''
      set -gx SSH_AUTH_SOCK /run/user/(id -u)/keyring/ssh
    '';
    systemd.user.services.gnome-keyring = {
      Service.Restart = lib.mkForce "always";
      Service.ExecStopPost = "${pkgs.lib.getExe pkgs.libnotify} -u normal -a Keyring \"Keyring needs to be re-unlocked\"";
    };
  };
}
