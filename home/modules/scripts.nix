{ pkgs, ... }:
let
  hypr_check_battery = pkgs.writeShellScriptBin "hypr_check_battery" ''
    BATINFO="$(acpi -b | grep -i discharging | awk '/Battery 0/{print $5;}')"
    if [ -z "$BATINFO" ]; then
        exit
    fi
    if [[ "$BATINFO" < 00:10:00 ]]; then
        notify-send -a Battery -i Battery -u critical "Battery critical!" "Please plug in."
    fi
  '';

  hypr_powermenu = pkgs.writeShellScriptBin "hypr_powermenu" ''
    if ! pgrep -x wlogout; then
        wlogout -b 5
    fi
  '';

  hypr_screenshot = pkgs.writeShellScriptBin "hypr_screenshot" ''
    exec hyprshot -m region --freeze --clipboard-only
  '';

  hypr_select_audio_sink = pkgs.writeShellScriptBin "hypr_select_audio_sink" ''
    which=$(pw-dump | jq -r '.[] | select(.info.props."media.class" == "Audio/Sink") | .info.props."node.description"' | fuzzel -d -p 'Audio Sink' | tr -d '\n')
    if [ -z "$which" ]; then
        exit 0
    fi
    id=$(pw-dump | jq -r --arg which "$which" '.[] | select(.info.props."media.class" == "Audio/Sink" and .info.props."node.description" == $which) | .info.props."object.id"')
    wpctl set-default $id \
    && notify-send -t 1500 -a Audio "Switched to audio sink $which" \
    || notify-send -t 1500 -a Audio -u critical "Failed to switch audio sink."
  '';

  hypr_suspend = pkgs.writeShellScriptBin "hypr_suspend" ''
    systemctl suspend
    hyprlock
  '';
in
{
  home.packages = [
    hypr_check_battery
    hypr_powermenu
    hypr_screenshot
    hypr_select_audio_sink
    hypr_suspend
  ];
}
