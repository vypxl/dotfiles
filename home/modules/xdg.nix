# Configures default applications
{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    xdg.enable = mkEnableOption "xdg";
  };

  config = lib.mkIf cfg.xdg.enable {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = lib.concatMapAttrs (key: list: lib.genAttrs list (_: key)) {
        "dev.zed.Zed.desktop" = [
          "text/plain"
          "application/json"
          "application/toml"
          "application/yaml"
        ];
      };
    };
  };
}
