{ ... }:
{
  xdg.configFile."yamllint/config".text = ''
    ---

    yaml-files:
      - '*.yaml'
      - '*.yml'
      - '.yamllint'

    rules:
      braces: enable
      brackets: enable
      colons: enable
      commas: enable
      comments:
        level: warning
      comments-indentation:
        level: warning
      document-end: disable
      document-start: disable
      empty-lines: disable
      empty-values: disable
      float-values: disable
      hyphens: enable
      indentation: enable
      key-duplicates: enable
      key-ordering: disable
      line-length: disable
      new-line-at-end-of-file: enable
      new-lines: enable
      octal-values: disable
      quoted-strings: disable
      trailing-spaces: enable
      truthy: disable
  '';
}
