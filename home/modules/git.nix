{ config, ... }:
{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        line-numbers = true;
        navigate = true;
        dark = true;
      };
    };

    userName = "vypxl";
    userEmail = "thomas@vypxl.io";
    signing.key = "/home/thomas/.ssh/id_ed25519.pub";

    signing.signByDefault = true;

    aliases.h = "log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %C(green)(%G?) %Creset%s' --graph --date=relative --date-order";
    aliases.uncommit = "reset --soft HEAD^";

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

    extraConfig = {
      init = {
        defaultBranch = "main";
      };

      merge = {
        conflictStyle = "zdiff3";
      };

      pull = {
        rebase = true;
      };

      diff = {
        colorMoved = "default";
      };

      submodule = {
        recurse = true;
      };

      gpg = {
        format = "ssh";
      };

      gpg.ssh = {
        allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
      };
    };
  };

  home.file.".ssh/allowed_signers".text = ''
    thomas@vypxl.io ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGdcyJt7QCpshfGWnjWsomJ3EbZI3k/xuWVdcpOP57TL
  '';
}
