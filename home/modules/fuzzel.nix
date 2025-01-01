{ pkgs, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Fira Code:size=18";
        lines = 5;
        horizontal-pad = 10;
        vertical-pad = 20;
        inner-pad = 20;
        fields = "name,generic,comment,categories,filename,keywords";
        terminal = "kitty";
        prompt = "❯ ";
        use-bold = true;
        password-character = "•";
        list-executables-in-path = true;
        launch-prefix = "uwsm-app --";
      };

      border = {
        radius = 20;
        width = 2;
      };

      dmenu = {
        exit-immediately-if-empty = true;
      };

      # https://github.com/catppuccin/fuzzel/blob/main/themes/catppuccin-macchiato/lavender.ini
      colors = {
        background = "24273add";
        text = "cad3f5ff";
        prompt = "b8c0e0ff";
        placeholder = "8087a2ff";
        input = "cad3f5ff";
        match = "b7bdf8ff";
        selection = "5b6078ff";
        selection-text = "cad3f5ff";
        selection-match = "b7bdf8ff";
        counter = "8087a2ff";
        border = "b7bdf8ff";
      };
    };
  };

  # For calculating with =
  # https://github.com/ClemaX/menu-qalc-wayland
  home.packages = [
    pkgs.libqalculate
    (pkgs.writeShellScriptBin "=" ''
      # https://github.com/onespaceman/menu-qalc
      # Calculator for use with wofi/fuzzel/dmenu(2)
      # Copying to the clipboard requires wl-clipboard

      usage() {
          echo "$(tput bold)menu-qalc$(tput sgr0)"
          echo "A calculator for Wofi/fuzzel/dmenu(2)"
          echo
          echo "$(tput bold)Usage:$(tput sgr0)"
          echo "    = 4+2"
          echo "    = (4+2)/(4+3)"
          echo "    = 4^2"
          echo "    = sqrt(4)"
          echo "    = c(2)"
          echo
          echo "$(tput bold)Force Wofi/fuzzel/dmenu(2):$(tput sgr0)"
          echo "By default, if wofi exists, it will be used. To force menu-qalc to"
          echo "use one or the other, use the --dmenu argument"
          echo
          echo "    = --dmenu=<dmenu_executable>"
          echo
          echo "$(tput bold)Passing arguments to Wofi/fuzzel/dmenu(2):$(tput sgr0)"
          echo "Any parameters after ' -- ' will be passed to Wofi/fuzzel/dmenu(2)."
          echo
          echo "    = -- <Wofi/fuzzel/dmenu(2) args>"
          echo
          echo "The answer can be copied to the clipboard and used for further calculations inside (or outside) Wofi/fuzzel/dmenu."
          echo
          echo "If launched outside of Wofi/fuzzel/dmenu the expression may need quotation marks."
          exit
      }

      process_query() { # query
          local query="$1"

          qalc +u8 -color=never -terse <<< "$query" \
          | awk '!/^>/ && !/^$/ {gsub(/^[ \t]+|[ \t]+$/, "", $0); print}'
      }

      # Process CLI parameters
      for arg in "$@"
      do
          case "$arg" in
              -h|--help) usage ;;
              -d=*|--dmenu=*)
                  menu=$(echo "$arg" | cut -d'=' -f 2);
                  ;;
              --) break ;;
          esac
      done

      # Path to menu application
      if [ -z "''${menu+1}" ]; then
          for dmenu_exec in dmenu wofi fuzzel ; do
              if [[ -n $(command -v "$dmenu_exec") ]]; then
                  menu="$dmenu_exec"
              fi
          done

          if [ -z "''${menu+1}" ]; then
              >&2 echo "Wofi, fuzzel or dmenu not found"
              exit
          fi

          menu_cmd=("$(command -v "$menu")")
      fi

      # If using wofi or fuzzel, add the necessary parameters
      if [[ $menu == "wofi" || $menu == "fuzzel" ]]; then
          menu_cmd+=(--dmenu --lines 3)
      elif [[ $menu == "dmenu" ]] && [ -n "''${DMENU_OPTIONS+1}" ]; then
          read -ra options <<< "$DMENU_OPTIONS"

          menu_cmd+=("''${options[@]}")

          unset options
      fi

      # User query
      query="$1"

      # Determine args to pass to dmenu/wofi
      while [[ $# -gt 0 && $1 != "--" ]]; do
          shift
      done
      [[ $1 == "--" ]] && shift

      answer=

      while true; do
          action=$(echo -e "Copy\nClear\nClose" | "''${menu_cmd[@]}" "$@" -p "= $answer")

          case "$action" in
              "Clear") answer= ;;
              "Copy") wl-copy "$answer";;
              "Close"|"") exit ;;
              *) answer=$(process_query "$answer $action") ;;
          esac
      done
    '')
  ];
}
