{ config, lib, ... }:
let
  cfg = config.my;
in
{
  options.my = with lib; {
    git.enable = mkEnableOption "git";
  };

  config = lib.mkIf cfg.git.enable {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        enable = true;
        options = {
          line-numbers = true;
          navigate = true;
          dark = true;
        };
      };
    };

    programs.git = {
      enable = true;

      signing = {
        format = "ssh";
        key = "/home/thomas/.ssh/id_ed25519.pub";
        signByDefault = true;
      };

      settings = {
        alias.h = "log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %C(green)(%G?) %Creset%s' --graph --date=relative --date-order";
        alias.uncommit = "reset --soft HEAD^";

        commit.gpgSign = true;

        diff.colorMoved = "default";

        gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";

        init.defaultBranch = "main";

        merge.conflictStyle = "zdiff3";

        pull.rebase = true;

        rebase.autoStash = true;

        submodule.recurse = true;
        
        tag.gpgSign = true;

        user.name = "vypxl";
        user.email = "thomas@vypxl.io";
      };

      includes = [
        {
          path = "~/.config/git/config.work";
          condition = "gitdir:~/work/";
        }
        {
          path = "~/.config/git/config.uni";
          condition = "gitdir:~/dev/uni/";
        }
      ];
    };

    home.file.".ssh/allowed_signers".text = ''
      thomas@vypxl.io ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGdcyJt7QCpshfGWnjWsomJ3EbZI3k/xuWVdcpOP57TL
    '';
  };
}
