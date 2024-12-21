{ config, pkgs, ... }:
with import ../src/util.nix config;
{
  home.packages = [ pkgs.zed-editor ];
  xdg.configFile."zed" = dotfile_dir_mut "zed";
}
