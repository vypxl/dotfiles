{ ... }:
{
  programs.pylint.enable = true;
  programs.pylint.settings = {
    "MESSAGES CONTROL" = {
      disable = "invalid-name, missing-module-docstring, missing-function-docstring, line-too-long, redefined-builtin, wildcard-import, unnecessary-lambda-assignment, import-error, too-many-arguments";
    };
  };
}
