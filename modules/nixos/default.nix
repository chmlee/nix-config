{ inputs, self, ... }:
{
  imports = [
    ./infra
    ./services
    ./os
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs self; };

  home-manager.sharedModules = [
    self.homeManagerModules.default
  ];
}
