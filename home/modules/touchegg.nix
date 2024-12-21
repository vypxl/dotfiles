{ config, pkgs, ... }:
with import ../src/util.nix config;
{
  home.packages = [ pkgs.touchegg ];
  xdg.configFile."touchegg" = dotfile_dir "touchegg";
}
