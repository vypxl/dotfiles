{ config, pkgs, ... }:
with import ../src/util.nix config;
{
  home.packages = [ pkgs.rofi ];
  xdg.configFile."rofi" = dotfile_dir "rofi";
}
