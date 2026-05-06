{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {

      nixosModules.default = import ./modules/nixos;
      homeManagerModules.default = import ./modules/home;

      nixosConfigurations.T14p = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs self; };
        modules = [
          ./hosts/T14p/configuration.nix

          ./users/default.nix
          self.nixosModules.default

          inputs.disko.nixosModules.disko
          inputs.impermanence.nixosModules.impermanence
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs self; };
          }
        ];
      };
    };
}
