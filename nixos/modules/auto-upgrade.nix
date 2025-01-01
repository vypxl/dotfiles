{ self, ... }:
{
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
}
