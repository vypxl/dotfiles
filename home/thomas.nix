{ pkgs, lib, ... }:
{
  xdg.enable = true;
  imports = [ ./default.nix ];

  home.packages =
    with import ./src/packages.nix pkgs;
    lib.lists.concatLists [
      base
      graphical
      lsp
      languages
    ];

  services.udiskie.enable = true;
  services.mpris-proxy.enable = true; # bt media control

  home.sessionVariables.EDITOR = "nvim";

  my.dotfile."file_templates".mut = true;

  home.stateVersion = "24.11";
}
