{ pkgs, kache, ... }:
let
  kachePackage = kache.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  imports = [ ./default.nix ];

  my.bundle.desktop.enable = true;
  my.niri.enable = true;
  my.android.enable = true;

  home.packages = [ kachePackage ];
  home.file.".cargo/config.toml".text = ''
    [build]
    rustc-wrapper = "${kachePackage}/bin/kache"
  '';

  home.stateVersion = "24.11";
}
