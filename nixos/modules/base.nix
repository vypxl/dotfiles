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
    base.enable = mkEnableOption "base";
  };

  config = lib.mkIf cfg.base.enable {
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    environment.systemPackages = with pkgs; [
      git
      vim
      wget
      comma
    ];
  };
}
