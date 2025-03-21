{ config, lib, ... }:
let
  cfg = config.my;
  fun = name: {
    body = builtins.readFile ../../config/fish/functions/${name}.fish;
  };
in
{
  options.my = with lib; {
    fish.enable = mkEnableOption "fish";
  };

  config = lib.mkIf cfg.fish.enable {
    programs.fish = {
      enable = true;
      shellAbbrs = {
        g = "git";
        "ga." = "git add .";
        ga = "git add";
        gst = "git status";
        gcm = "git commit -am";
        lg = "lazygit";
        zj = "zellij -l thomas";

        d = "docker";
        dc = "docker compose";
        c = "cargo";
        n = "nix";
        m = "clac";
        j = "just";
        pn = "pnpm";
        cm = "cmake";

        md = "mkdir";
        nixi = "nix profile install nixpkgs#";
        nixr = "nix run nixpkgs#";
        venv = "source .venv/bin/activate.fish";
      };
      shellAliases = {
        ls = "eza --git";
        ll = "ls -l";
        la = "ls -al";
        lr = "ls -alR";
        "." = "ls -l";

        vim = "nvim";
        vimp = ''nvim "+lua require('persistence').load()"'';
        icat = "kitty +kitten icat";
        killbg = "jobs -p | tail -n 1 | xargs kill -9; fg";
      };
      functions = {
        "format_command_duration" = fun "format_command_duration";
        "fish_mode_prompt" = "";
        "fish_prompt" = fun "fish_prompt";
        "fish_right_prompt" = fun "fish_right_prompt";

        "chxdg" = fun "chxdg";

        "reload" = "source ~/.config/fish/config.fish";
        "pls" = ''
          commandline -i "sudo $history[1]"
          history delete --exact --case-sensitive "pls"
          commandline -f execute
        '';
        "vz" = ''
          set f (fzf)
          test -n "$f" && vim "$f"
        '';
        "cz" = ''
          set d (fd -Htd | fzf)
          test -n "$d" && cd "$d"
        '';
        "cdd" = ''
          command mkdir -p $argv
          cd $argv
        '';
      };
      interactiveShellInit = ''
        fish_vi_key_bindings
      '';
      loginShellInit = '''';
      shellInit = '''';
    };
  };
}
