{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    shell-utils.enable = mkEnableOption "shell-utils";
  };

  config = lib.mkIf cfg.shell-utils.enable {
    programs.fzf = {
      enable = true;
      defaultCommand = "fd -Htf";
      defaultOptions = [
        "--height=90%"
        "--preview-window=down:80%"
        "--preview='bat -n --color=always -r=:500 {}'"
      ];
    };
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--hidden"
        "--glob=!.git/*"
        "--max-columns-preview"
        "--smart-case"
      ];
    };
    programs.zoxide.enable = true;
  };
}
