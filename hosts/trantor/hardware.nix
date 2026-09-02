{ lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Trantor does not use Linux MD software RAID.
  boot.swraid.enable = false;
}
