{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    mod.enable = mkEnableOption "mod";
  };

  config = lib.mkIf cfg.mod.enable {

  };
}
