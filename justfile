host := `hostname`

apply:
  sudo nixos-rebuild switch --flake '.#{{host}}'

boot:
  sudo nixos-rebuild boot --flake '.#{{host}}'

new which name:
  cp _module_template.nix {{which}}/modules/{{name}}.nix

eval:
  nix eval .#nixosConfigurations.{{host}}.config.system.build.toplevel

build:
  nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel
