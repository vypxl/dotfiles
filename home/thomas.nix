{ ... }:
{
  imports = [ ./default.nix ];

  my.bundle.desktop.enable = true;
  my.niri.enable = true;
  my.android.enable = true;

  home.stateVersion = "24.11";
}
