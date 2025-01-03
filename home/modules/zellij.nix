{ pkgs, ... }:
{
  home.packages = [ pkgs.zellij ];
  my.dotfile."zellij".enable = true;
}
