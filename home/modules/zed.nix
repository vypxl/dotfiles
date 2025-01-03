{ pkgs, ... }:
{
  home.packages = [ pkgs.zed-editor ];
  my.dotfile."zed".mut = true;
}
