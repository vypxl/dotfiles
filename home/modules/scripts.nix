{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my;
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

  context7-mcp = pkgs.writeShellScriptBin "context7-mcp" ''
    set -euo pipefail

    SERVICE="context7"
    ACCOUNT="api-key"

    get_key_from_keyring() {
      ${pkgs.libsecret}/bin/secret-tool lookup service "$SERVICE" account "$ACCOUNT" 2>/dev/null || true
    }

    save_key_to_keyring() {
      local key="$1"
      echo -n "$key" | ${pkgs.libsecret}/bin/secret-tool store \
        --label="Context7 API Key" \
        service "$SERVICE" \
        account "$ACCOUNT"
    }

    validate_api_key() {
      local key="$1"
      if [ -z "$key" ]; then
        return 1
      fi
      local http_code
      http_code=$(${pkgs.curl}/bin/curl -s -o /dev/null -w "%{http_code}" \
        -X GET "https://context7.com/api/v1/search?query=test" \
        -H "Authorization: Bearer $key")
      [ "$http_code" = "200" ]
    }

    prompt_terminal() {
      echo -n "Enter Context7 API Key: " >&2
      read -rs key
      echo >&2
      echo "$key"
    }

    prompt_zenity() {
      ${pkgs.zenity}/bin/zenity --entry \
        --title="Context7 API Key" \
        --text="Enter API key:" \
        --hide-text \
        2>/dev/null || true
    }

    prompt_for_key() {
      if [ -n "''${DISPLAY:-}''${WAYLAND_DISPLAY:-}" ]; then
        prompt_zenity
      else
        prompt_terminal
      fi
    }

    prompt_and_validate() {
      local key
      key=$(prompt_for_key)

      if [ -z "$key" ]; then
        echo "Error: No API key provided." >&2
        exit 1
      fi

      if ! validate_api_key "$key"; then
        echo "Error: Invalid API key." >&2
        exit 1
      fi

      save_key_to_keyring "$key"
      echo "API key saved to keyring." >&2
      echo "$key"
    }

    API_KEY=$(get_key_from_keyring)

    if [ -z "$API_KEY" ]; then
      API_KEY=$(prompt_and_validate)
    elif ! validate_api_key "$API_KEY"; then
      echo "Stored API key is invalid. Please enter a new one." >&2
      API_KEY=$(prompt_and_validate)
    fi

    exec ${pkgs.nodejs}/bin/npx -y @upstash/context7-mcp --api-key "$API_KEY"
  '';

  secret = pkgs.writeShellScriptBin "secret" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    SECRET_TOOL=${pkgs.libsecret}/bin/secret-tool
    ZENITY=${pkgs.zenity}/bin/zenity
    SERVICE="secret-cli"

    usage() {
      cat <<-EOF
    secret: a simple secret cli based on secret-tool

    Usage:
      secret set <key>    # read secret from stdin
      secret get <key>    # retrieve secret value
      secret init <key>   # get secret and set if not already set
      secret rm <keys>    # remove secret from keyring
      secret ls           # list all secrets (keys only)

      secret wrap <keys> <cmd> [args]  # export the given secrets as env vars and run the command

    Notes:
      - commands that accept multiple keys (rm, wrap) accept a comma separated list of keys
    EOF
      exit 2
    }

    cmd="''${1:-}"
    key="''${2:-}"

    [[ -n "$cmd" ]] || usage

    store() {
      key="$1"
      "$SECRET_TOOL" store --label="secret $key" service "$SERVICE" account "$key"
    }

    lookup() {
      key="$1"
      "$SECRET_TOOL" lookup service "$SERVICE" account "$key"
    }

    # like store, but falls back to zenity if stdin is not a tty
    init() {
      key="$1"
      # if stdin is a tty, prompt for the secret
      # otherwise, prompt using zenity
      if [[ -t 0 ]]; then
        echo "Secret '$key' is not set, enter it now:" >&2
        store "$key"
      else
        "$ZENITY" --password --title="Secret '$key'" 2>/dev/null | store "$key"
      fi
    }

    split() {
      local input="$1"
      local -n dest="$2"
      IFS=',' read -ra dest <<< "$input"
    }

    case "$cmd" in
      set|store|s)
        [[ -n "$key" ]] || usage
        store "$key"
        ;;
      get|lookup|l|g)
        [[ -n "$key" ]] || usage
        lookup "$key"
        ;;
      init)
        [[ -n "$key" ]] || usage
        sec=$(lookup "$key" || true)
        if [[ -n "$sec" ]]; then
          echo "$sec"
        else
          init "$key"
          lookup "$key"
        fi
        ;;
      delete|drop|rm)
        [[ -n "$key" ]] || usage
        split "$key" keys
        for k in "''${keys[@]}"; do
          "$SECRET_TOOL" clear service "$SERVICE" account "$k"
        done
        ;;
      wrap)
        [[ -n "$key" ]] || usage
        [[ -n "$3" ]] || usage
        split "$key" keys
        for k in "''${keys[@]}"; do
          lookup "$k" >/dev/null 2>&1 || init "$k"
          export "$k"=$(lookup "$k")
        done
        exec "$3" "''${@:4}"
        ;;
      list|ls)
        "$SECRET_TOOL" search service "$SERVICE" --all 2>&1 | awk '/^attribute\.account/ {print $3}'
        ;;
      *)
        echo "unknown command: $cmd" >&2
        usage
        ;;
    esac
  '';

  git-compact-status = pkgs.writeShellScriptBin "git-compact-status" ''
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
      exit 0
    fi

    if [ -n "$(git stash list)" ]; then
      echo -n "$"
    fi

    if [ -n "$(git diff --name-only)" ]; then
      echo -n "!"
    fi

    if [ -n "$(git diff --name-only --staged)" ]; then
      echo -n "+"
    fi

    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
      echo -n "?"
    fi

    if [ -n "$(git rev-list @{u}..HEAD 2>/dev/null)" ]; then
      echo -n "↑"
    fi

    if [ -n "$(git rev-list HEAD..@{u} 2>/dev/null)" ]; then
      echo -n "↓"
    fi
  '';
in
{
  options.my = with lib; {
    scripts.enable = mkEnableOption "scripts";
  };

  config = lib.mkIf cfg.scripts.enable {
    home.packages = [
      hypr_check_battery
      hypr_powermenu
      hypr_screenshot
      hypr_select_audio_sink
      hypr_suspend

      git-compact-status
      secret
      context7-mcp
    ];
  };
}
