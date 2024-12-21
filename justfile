apply:
  sudo nixos-rebuild switch --flake '.#stone'

new which name:
  cp templates/{{which}}.nix {{which}}/modules/{{name}}.nix
