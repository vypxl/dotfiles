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
    android.enable = mkEnableOption "android ";
  };

  config = lib.mkIf cfg.android.enable {
    home.packages = with pkgs.unstable; [
      android-studio
      # jetbrains-toolbox
    ];
  };
}
