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
    syncthing.enable = mkEnableOption "syncthing";
  };

  config = lib.mkIf cfg.syncthing.enable {
    home.packages = [ pkgs.syncthingtray-minimal ];
    services.syncthing = {
      enable = true;
    };
  };
}
