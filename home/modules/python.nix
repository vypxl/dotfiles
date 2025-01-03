{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    python.enable = mkEnableOption "python";
  };

  config = lib.mkIf cfg.python.enable {
    home.sessionVariables."PYTHONSTARTUP" = "$XDG_CONFIG_HOME/python/init.py";
    xdg.configFile."python/init.py".text = ''
      import math
      import time
      import json
      import re
      import itertools as it
    '';

    programs.pylint.enable = true;
    programs.pylint.settings = {
      "MESSAGES CONTROL" = {
        disable = "invalid-name, missing-module-docstring, missing-function-docstring, line-too-long, redefined-builtin, wildcard-import, unnecessary-lambda-assignment, import-error, too-many-arguments";
      };
    };
  };
}
