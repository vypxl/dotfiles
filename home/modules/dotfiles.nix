{ config, lib, ... }:
with lib;
let
  cfg = config.my.dotfile;
in
{
  options.my = {
    dotfile = mkOption {
      description = "Files that should be put into $XDG_CONFIG_HOME, sourced from dots/config";
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              enable = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether this file should be generated. This option allows specific
                  files to be disabled.
                '';
              };

              target = mkOption {
                type = types.str;
                defaultText = literalExpression "name";
                default = name;
                description = ''
                  Path to target file relative to $XDG_CONFIG_HOME.
                '';
              };

              source = mkOption {
                type = types.str;
                defaultText = literalExpression "name";
                default = name;
                description = ''
                  Path of the source file relative to dots/config.
                '';
              };

              mut = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Whether the file should be symlinked instead of copied.
                '';
              };
            };
          }
        )
      );
    };
  };

  config.xdg.configFile = mkMerge (
    mapAttrsToList (_: item: {
      "${item.target}" = (
        if item.mut then
          {
            enable = item.enable;
            source = config.lib.file.mkOutOfStoreSymlink "/home/${config.home.username}/dots/config/${item.source}";
          }
        else
          {
            enable = item.enable;
            source = ../../config/${item.source};
            recursive = true;
          }
      );
    }) cfg
  );
}
