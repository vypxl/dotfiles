{ pkgs, ... }:
{
  home.packages = [
    pkgs.seahorse
    pkgs.gcr
  ];
  services.gnome-keyring.enable = true;
  programs.fish.shellInit = ''
    set -gx SSH_AUTH_SOCK /run/user/(id -u)/keyring/ssh
  '';
}
