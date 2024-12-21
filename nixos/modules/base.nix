{ pkgs, ... }:
{
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    comma
  ];
}
