{ modulesPath, lib, ... }:

let
  systemId = "scsi-0QEMU_QEMU_HARDDISK_110162268";
  stateId = "scsi-0HC_Volume_104473479";
  systemDevice = "/dev/disk/by-id/${systemId}";
  stateDevice = "/dev/disk/by-id/${stateId}";
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  networking.hostName = "trantor";
  networking.useDHCP = lib.mkDefault true;

  my.os.core.enable = true;

  my.infra.disko.twoDisk = {
    enable = true;
    inherit systemDevice stateDevice;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8hnz1WkRNCBybhR+FKJfxt/bxaMeqivBGSz55rIRr7 louis@T14p"
  ];

  users.mutableUsers = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "26.05";
}
