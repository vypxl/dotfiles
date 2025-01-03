{ config, lib, pkgs, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    zellij.enable = mkEnableOption "zellij";
  };

  config = lib.mkIf cfg.zellij.enable {
  home.packages = [ pkgs.zellij ];
  my.dotfile."zellij".enable = true;
}
;}