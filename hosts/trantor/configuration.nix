{
  modulesPath,
  lib,
  pkgs,
  ...
}:

let
  osId = "scsi-0QEMU_QEMU_HARDDISK_120278671";
  dataId = "scsi-0HC_Volume_104473479";
  osDevice = "/dev/disk/by-id/${osId}";
  dataDevice = "/dev/disk/by-id/${dataId}";
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  environment.systemPackages = with pkgs; [
    vim
    btrfs-progs
  ];

  networking.hostName = "trantor";
  networking.useDHCP = lib.mkDefault true;

  # my.os.core.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  my.infra.disko.btrfs = {
    enable = true;
    topology = "dual-disk";

    disks = {
      os = {
        device = osDevice;
        encrypted = false;
      };

      data = {
        device = dataDevice;
        encrypted = false;
      };
    };

    filesystems = {
      os = {
        disk = "os";
        subvolumes = [
          "root"
          "nix"
        ];
      };

      data = {
        disk = "data";
        subvolumes = [
          "persist"
          "data"
          "postgresql"
        ];
      };
    };
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8hnz1WkRNCBybhR+FKJfxt/bxaMeqivBGSz55rIRr7 louis@T14p"
    ];
  };

  # users.mutableUsers = false;

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "25.11";
}
