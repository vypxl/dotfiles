{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # FIXME: pinned to v1.12.0 to work around disko#1203 (--vm-test broken with nixpkgs 25.11)
    # https://github.com/nix-community/disko/issues/1203
    disko.url = "github:nix-community/disko/ff442f5d1425feb86344c028298548024f21256d";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    hermes-agent.url = "github:NousResearch/hermes-agent";
    hermes-agent.inputs.nixpkgs.follows = "nixpkgs";

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      flake-utils,
      nix-index-database,
      sops-nix,
      hermes-agent,
      disko,
      dankMaterialShell,
      ...
    }@attrs:
    let
      overlayFor = system: final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          config.android_sdk.accept_license = true;
        };
      };
      machine =
        {
          hostname,
          username ? "thomas",
          system ? "x86_64-linux",
          withHome ? true,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = attrs;
          modules = [
            { nixpkgs.overlays = [ (overlayFor system) ]; }
            nix-index-database.nixosModules.nix-index
            sops-nix.nixosModules.sops
            disko.nixosModules.disko
            hermes-agent.nixosModules.default
            ./hosts/${hostname}/configuration.nix
          ]
          ++ nixpkgs.lib.optionals withHome [
            home-manager.nixosModules.default
            {
              home-manager.extraSpecialArgs = { inherit hostname dankMaterialShell; };
              home-manager.backupFileExtension = "hmbak";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${username}" = import ./home/${username}.nix;
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        stone = machine { hostname = "stone"; };
        slate = machine { hostname = "slate"; };
        zephyr = machine { hostname = "zephyr"; };
        armada = machine {
          hostname = "armada";
          system = "aarch64-linux";
          withHome = false;
        };
      };
    }
    // flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (overlayFor system) ];
          config.allowUnfree = true;
        };
        get-age-key = pkgs.writeShellScriptBin "get-age-key" ''
          set -euo pipefail

          SSH_KEY="''$HOME/.ssh/id_ed25519"
          SECRET_LABEL="SOPS Age Key"
          ATTR_KEY="application"
          ATTR_VAL="sops-age-key"

          # Attempt lookup
          AGE_KEY=$(secret-tool lookup "$ATTR_KEY" "$ATTR_VAL" 2>/dev/null || true)

          if [ -z "$AGE_KEY" ]; then
              echo "Age key not saved. Enter SSH key passphrase: " >&2
              read -s SSH_TO_AGE_PASSPHRASE
              export SSH_TO_AGE_PASSPHRASE
              if ! AGE_KEY=$(ssh-to-age -private-key -i "$SSH_KEY"); then
                  echo "Error: Failed to convert SSH key." >&2
                  exit 1
              fi

              echo -n "$AGE_KEY" | secret-tool store --label="$SECRET_LABEL" "$ATTR_KEY" "$ATTR_VAL"
          fi

          echo "$AGE_KEY"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            libsecret
            sops
            get-age-key
            ssh-to-age
            kubectl
            kubernetes-helm
            fluxcd
            k9s
            oci-cli
            terraform
          ];

          shellHook = ''
            export SOPS_AGE_KEY_CMD="get-age-key"
            export KUBECONFIG="$PWD/.kubectl.yaml"

            # OCI Object Storage doesn't support AWS chunked encoding
            export AWS_REQUEST_CHECKSUM_CALCULATION=WHEN_REQUIRED
            export AWS_RESPONSE_CHECKSUM_VALIDATION=WHEN_REQUIRED
          '';
        };
      }
    );
}
