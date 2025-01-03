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
    bat.enable = mkEnableOption "bat";
  };

  config = lib.mkIf cfg.bat.enable {
    programs.bat.enable = true;
    programs.bat.themes.catppuccin-macchiato = {
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "bat";
        rev = "d2bbee4f7e7d5bac63c054e4d8eca57954b31471";
        hash = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
      };
      file = "themes/Catppuccin Macchiato.tmTheme";
    };
    programs.bat.config = {
      theme = "catppuccin-macchiato";
    };
  };
}
