{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }@attrs:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      unstable-overlay =
        { ... }:
        {
          nixpkgs.overlays = [ overlay-unstable ];
        };
      hm-opts =
        { ... }:
        {
          home-manager.backupFileExtension = "hmbak";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        };
      hm-user = username: {
        home-manager.users."${username}" = import ./home/${username}.nix;
      };
      machine =
        hostname: username:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = attrs;
          modules = [
            unstable-overlay
            home-manager.nixosModules.default
            hm-opts
            (hm-user username)
            ./hosts/${hostname}/configuration.nix
          ];
        };
    in
    {
      nixosConfigurations.stone = machine "stone" "thomas";
    };
}
