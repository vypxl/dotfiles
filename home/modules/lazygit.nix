{ ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";
      };
    };
  };
}
