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
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
      "https://numtide.cachix.org"
      "s3://nix-binary-cache?profile=nix-cache&scheme=https&compression=zstd&endpoint=https://bdcd108ea508847194174597360224be.r2.cloudflarestorage.com"
    ];

    nix.settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "nix.nunu.ai:Ny6XbPOvwxCHlH1xK+6i8qwhBxFQj6O053aH4gEVn7U="
    ];

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
