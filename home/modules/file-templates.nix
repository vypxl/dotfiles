{ config, lib, ... }:
{
  options.my.file-templates.enable = lib.mkEnableOption "Make file_templates available";
  config.my.dotfile."file_templates".mut = config.my.file-templates.enable;
}
