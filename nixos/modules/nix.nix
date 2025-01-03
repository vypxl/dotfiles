{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    nix.enable = mkEnableOption "nix";
  };

  config = lib.mkIf cfg.nix.enable {
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
