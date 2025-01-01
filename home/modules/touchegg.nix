{ config, pkgs, ... }:
with import ../src/util.nix config;
{
  # requires system service for touchegg
  xdg.configFile."touchegg" = dotfile_dir "touchegg";
}
