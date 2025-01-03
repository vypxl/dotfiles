host := `hostname`

apply:
  sudo nixos-rebuild switch --flake '.#{{host}}'

new which name:
  cp templates/{{which}}.nix {{which}}/modules/{{name}}.nix

eval:
  nix eval .#nixosConfigurations.{{host}}.config.system.build.toplevel

build:
  nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel
