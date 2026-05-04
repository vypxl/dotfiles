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

# OCI / Terraform
oci-login:
  oci session authenticate

oci-refresh:
  oci session refresh

tf-init:
  cd terraform && terraform init

tf-plan:
  cd terraform && terraform plan

tf-apply:
  cd terraform && terraform apply

get-kubeconfig-armada:
  ssh lab.vypxl.io cat /etc/rancher/k3s/k3s.yaml \
    | sed 's|server: https://127.0.0.1:6443|server: https://lab.vypxl.io:6443|' \
    > .kubectl.yaml
