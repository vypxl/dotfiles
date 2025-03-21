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
    zed.enable = mkEnableOption "zed";
  };

  config = lib.mkIf cfg.zed.enable {
    home.packages = [ pkgs.unstable.zed-editor ];
    my.dotfile."zed".mut = true;
    programs.fish.shellAliases.zed = "zeditor";
  };
}
