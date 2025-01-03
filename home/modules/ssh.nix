{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    ssh.enable = mkEnableOption "ssh";
  };

  config = lib.mkIf cfg.ssh.enable {
    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      compression = true;
      controlMaster = "auto";
      controlPath = "~/.ssh/control-%r@%h:%p";
      controlPersist = "10m";
    };
  };
}
