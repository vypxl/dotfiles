{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    hermes-agent.url = "github:NousResearch/hermes-agent";
    hermes-agent.inputs.nixpkgs.follows = "nixpkgs";

    # omnix.url = "github:juspay/omnix";
    # omnix.inputs.nixpkgs.follows = "nixpkgs";

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
      nix-index-database,
      sops-nix,
      hermes-agent,
      # omnix,
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
        # omnix = omnix.packages.${system};
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
    };
}
