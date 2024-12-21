{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  # boot.loader.systemd-boot.configurationLimit = 1;

  networking.hostName = "stone";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.udisks2.enable = true;

  users.defaultUserShell = pkgs.fish;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thomas = {
    isNormalUser = true;
    description = "Thomas";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    comma
  ];

  programs.fish.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  fileSystems = {
    "/".options = [ "compress=zstd" ];
  };

  system.stateVersion = "24.11";
}
