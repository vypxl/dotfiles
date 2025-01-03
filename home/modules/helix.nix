{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    helix.enable = mkEnableOption "helix";
  };

  config = lib.mkIf cfg.helix.enable {
    programs.helix = {
      enable = true;
      settings = {
        editor = {
          auto-save = true;
          bufferline = "multiple";
          color-modes = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          cursorline = true;
          indent-guides = {
            render = true;
          };
          lsp = {
            display-messages = true;
          };
          soft-wrap = {
            enable = true;
          };
          text-width = 120;
          whitespace = {
            characters = {
              nbsp = "⍽";
              nnbsp = "␣";
              tab = "→";
            };
            render = {
              nbsp = "all";
              nnbsp = "all";
              tab = "all";
            };
          };
        };
        keys = {
          normal = {
            A-S-left = ":buffer-previous";
            A-S-right = ":buffer-next";
            g = {
              t = "goto_type_definition";
              y = "no_op";
            };
            space = {
              s = ":write";
              x = ":buffer-close";
            };
          };
        };
        theme = "catppuccin_macchiato";
      };
    };
  };
}
