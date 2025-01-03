{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    lazygit.enable = mkEnableOption "lazygit";
  };

  config = lib.mkIf cfg.lazygit.enable {
    programs.lazygit = {
      enable = true;
      settings = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };
}
