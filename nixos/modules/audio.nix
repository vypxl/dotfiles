{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    audio.enable = mkEnableOption "audio";
  };

  config = lib.mkIf cfg.audio.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
