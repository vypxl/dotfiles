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
    nixpkgs.config.android_sdk.accept_license = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nix.settings.trusted-users = [ "@wheel" ];

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
