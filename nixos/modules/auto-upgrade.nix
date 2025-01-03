{
  self,
  config,
  lib,
  ...
}:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    auto-upgrade.enable = mkEnableOption "auto-upgrade";
  };

  config = lib.mkIf cfg.auto-upgrade.enable {
    system.autoUpgrade = {
      enable = true;
      flake = self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L" # print build logs
      ];
      dates = "Sat, 02:00";
      randomizedDelaySec = "45min";
      persistent = true;
      allowReboot = false;
    };
  };
}
