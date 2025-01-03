{ lib, ... }:
with lib;
{
  options.my = {
    dotfile = mkOption {
      description = "Files that should be put into $XDG_CONFIG_HOME, sourced from dots/config";
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, config, ... }:
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
                type = types.path;
                defaultText = literalExpression "name";
                default = name;
                description = ''
                  Path of the source file relative to dots/config.
                '';
              };

              mut = mkOption {
                types = types.bool;
                default = false;
                description = ''
                  Whether the file should be symlinked instead of copied.
                '';
              };
            };

            config = {
              xdg.configFile."${config.target}" = mkIf config.enable (
                mkIf config.mut
                  { source = lib.file.mkOutOfStoreSymlink "/home/${home.username}/dots/config/${config.source}"; }
                  {
                    source = ../../config/${config.source};
                    recursive = true;
                  }
              );
            };
          }
        )
      );
    };
  };
}
