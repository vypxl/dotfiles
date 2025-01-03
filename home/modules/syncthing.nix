{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    syncthing.enable = mkEnableOption "syncthing";
  };

  config = lib.mkIf cfg.syncthing.enable {
    services.syncthing = {
      enable = true;
      tray.enable = true;
    };
  };
}
