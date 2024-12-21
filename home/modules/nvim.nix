{ config, pkgs, ... }:
with import ../src/util.nix config;
{
  home.packages = [ pkgs.neovim ];
  xdg.configFile."nvim" = dotfile_dir_mut "nvim";
}
