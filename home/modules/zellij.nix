{ config, pkgs, ... }:
with import ../src/util.nix config;
{
  home.packages = [ pkgs.zellij ];
  xdg.configFile.zellij = dotfile_dir "zellij";
}
