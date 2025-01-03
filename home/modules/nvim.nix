{ pkgs, ... }:
{
  home.packages = [ pkgs.neovim ];
  my.dotfile."nvim".mut = true;
}
