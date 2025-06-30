{
  nix-index-database,
  pkgs,
  ...
}:
let
  script = pkgs.writeShellScriptBin "command-not-found.sh" ''
    #!/bin/sh

    # for bash 4
    # this will be called when a command is entered
    # but not found in the user’s path + environment
    command_not_found_handle () {
        # taken from http://www.linuxjournal.com/content/bash-command-not-found
        # - do not run when inside Midnight Commander or within a Pipe
        if [ -n "''${MC_SID-}" ] || ! [ -t 1 ]; then
            >&2 echo "$1: command not found"
            return 127
        fi

        toplevel=nixpkgs # nixpkgs should always be available even in NixOS
        cmd=$1
        attrs=$(${
          nix-index-database.packages.${pkgs.stdenv.system}.nix-index-with-db
        }/bin/nix-locate --minimal --no-group --type x --type s --whole-name --at-root "/bin/$cmd")
        len=$(echo -n "$attrs" | grep -c "^")

        case $len in
            0)
                >&2 echo "$cmd: command not found"
                ;;
            1)
                attrs=$(echo -n "$attrs" | sed 's/.out$//')
                >&2 cat <<EOF
    The program '$cmd' is currently not installed.
    You can add 'pkgs.$attrs' to your packages in your home manager or nixos configuration,
    or run it once with:

      , $attrs
      nix shell $toplevel#$attrs -c $cmd ...

    or open a shell with $attrs available:

      , -s $attrs
      nix shell $toplevel#$attrs
    EOF
                ;;
            *)
                >&2 cat <<EOF
    The program '$cmd' is currently not installed. It is provided by
    several packages. These are:
    EOF
                while read attr; do
                    >&2 echo "  $toplevel#$attr"
                done <<< "$attrs"
                ;;
        esac

        return 127 # command not found should always exit with 127
    }

    # for zsh...
    # we just pass it to the bash handler above
    # apparently they work identically
    command_not_found_handler () {
        command_not_found_handle $@
        return $?
    }
  '';
in
{
  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enable = false;
  environment.systemPackages = [
    nix-index-database.packages.${pkgs.stdenv.system}.nix-index-with-db
  ];

  programs.bash.interactiveShellInit = ''
    source ${script}/bin/command-not-found.sh
  '';

  programs.zsh.interactiveShellInit = ''
    source ${script}/bin/command-not-found.sh
  '';

  # See https://github.com/bennofs/nix-index/issues/126
  programs.fish.interactiveShellInit =
    let
      wrapper = pkgs.writeScript "command-not-found" ''
        #!${pkgs.bash}/bin/bash
        source ${script}/bin/command-not-found.sh
        command_not_found_handle "$@"
      '';
    in
    ''
      function __fish_command_not_found_handler --on-event fish_command_not_found
          ${wrapper} $argv
      end
    '';
}
