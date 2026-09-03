{
  description = "My NixOS flake";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    disko = {
      # url = "github:nix-community/disko/latest";
      url = "github:nix-community/disko/v1.12.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager = {
    #   # url = "github:nix-community/home-manager/release-26.05";
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-anywhere,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      mkHost =
        {
          host,
          specialArgs ? { },
          modules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs self;
          }
          // specialArgs;

          modules = [
            ./hosts/${host}/configuration.nix

            ./users/default.nix
            self.nixosModules.default

            inputs.disko.nixosModules.disko
            inputs.impermanence.nixosModules.impermanence
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs self;
              }
              // specialArgs;
            }
          ]
          ++ modules;
        };

      pkgs = nixpkgs.legacyPackages.${system};

      # mkTrantor =
      #   entryModule:
      #   nixpkgs.lib.nixosSystem {
      #
      #     specialArgs = {
      #       inherit inputs self;
      #     };
      #
      #     modules = [
      #       inputs.disko.nixosModules.disko
      #       inputs.sops-nix.nixosModules.sops
      #
      #       entryModule
      #     ];
      #   };
      #
      # mkTrantorScript =
      #   name: path:
      #   pkgs.writeShellApplication {
      #     inherit name;
      #
      #     runtimeInputs = [
      #       pkgs.coreutils
      #       pkgs.git
      #       pkgs.nix
      #     ];
      #
      #     text = builtins.readFile path;
      #   };
      #
      # trantorVm = mkTrantorScript "trantor-vm" ./hosts/trantor/scripts/run-vm.sh;
      #
      # trantorInstallTest = mkTrantorScript "trantor-install-test" ./hosts/trantor/scripts/test-install.sh;
      #
    in
    {
      # packages.${system}.nixos-anywhere = nixos-anywhere.packages.${system}.nixos-anywhere;
      # packages.${system}.trantor-vm = trantorVm;
      # packages.${system}.trantor-install-test = trantorInstallTest;

      packages.${system} = {
        nixos-anywhere = nixos-anywhere.packages.${system}.nixos-anywhere;
        # trantor-vm = trantorVm;
        # trantor-install-test = trantorInstallTest;
      };

      nixosModules.default = import ./modules/nixos;

      homeManagerModules.default = import ./modules/home;

      nixosConfigurations = {
        T14p = mkHost { host = "T14p"; };

        # trantor = mkTrantor ./hosts/trantor/default.nix;
        # trantor-init = mkTrantor ./hosts/trantor/init.nix;
        # trantor-vm-test = mkTrantor ./hosts/trantor/vm-test.nix;
      };

      # apps.${system} = {
      #   nixos-anywhere = {
      #     type = "app";
      #     program = "${self.packages.${system}.nixos-anywhere}/bin/nixos-anywhere";
      #   };
      #   trantor-vm = {
      #     type = "app";
      #     program = "${trantorVm}/bin/trantor-vm";
      #   };
      #   trantor-install-test = {
      #     type = "app";
      #     program = "${trantorInstallTest}/bin/trantor-install-test";
      #   };
      # };

    };
}
