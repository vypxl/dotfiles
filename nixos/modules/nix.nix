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

    nix.settings.substituters = [
      "s3://nix-binary-cache?profile=nix-cache&scheme=https&compression=zstd&endpoint=https://bdcd108ea508847194174597360224be.r2.cloudflarestorage.com"
    ];

    nix.settings.trusted-public-keys = [
      "nix.nunu.ai:Ny6XbPOvwxCHlH1xK+6i8qwhBxFQj6O053aH4gEVn7U="
    ];

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
