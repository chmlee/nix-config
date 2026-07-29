{ ... }:

{
  imports = [
    ./hardware.nix
    ./boot.nix
    ./disk/system.nix
  ];

  networking.hostName = "trantor";

  system.stateVersion = "25.11";
}
