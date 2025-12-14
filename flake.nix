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

    omnix.url = "github:juspay/omnix";
    omnix.inputs.nixpkgs.follows = "nixpkgs";

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
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
      omnix,
      dankMaterialShell,
      ...
    }@attrs:
    let
      system = "x86_64-linux";
      overlay = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          config.android_sdk.accept_license = true;
        };
        omnix = omnix.packages.${system};
      };
      machine =
        hostname: username:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = attrs;
          modules = [
            { nixpkgs.overlays = [ overlay ]; }
            home-manager.nixosModules.default
            nix-index-database.nixosModules.nix-index
            {
              home-manager.extraSpecialArgs = { inherit hostname dankMaterialShell; };
              home-manager.backupFileExtension = "hmbak";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${username}" = import ./home/${username}.nix;
            }
            ./hosts/${hostname}/configuration.nix
          ];
        };
    in
    {
      nixosConfigurations = {
        stone = machine "stone" "thomas";
        slate = machine "slate" "thomas";
        zephyr = machine "zephyr" "thomas";
      };
    };
}
