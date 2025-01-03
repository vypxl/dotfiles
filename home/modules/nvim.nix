{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    nvim.enable = mkEnableOption "nvim";
  };

  config = lib.mkIf cfg.nvim.enable {
    home.packages = [ pkgs.neovim ];
    my.dotfile."nvim".mut = true;
  };
}
