{ config, lib, pkgs, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    fish.enable = mkEnableOption "fish";
  };

  config = lib.mkIf cfg.fish.enable {
    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;
  };
}
