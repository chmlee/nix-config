{ ... }:
let
  osDevice = "/dev/disk/by-id/nvme-WDBRPG0010BNC-WRSN_21034A800817";
  dataDevice = "/dev/disk/by-id/nvme-UMIS_RPJYJ1T24MML1AWQ_SS1D71533X1RC53B20DD";
in
{
  imports = [
    ./hardware.nix
  ];

  my.os = {
    core.enable = true;
    fonts.enable = true;

    virt = {
      enable = true;
      users = [ "louis" ];
    };
  };

  my.infra = {
    sops = {
      enable = true;
      defaultSopsFile = ../../secrets.yaml;
      ageKeyFile = "/persist/sops/key.txt";
    };
  };

  my.infra.disko.btrfs = {
    enable = true;
    topology = "dual-disk";

    disks = {
      os = {
        device = osDevice;
        encrypted = true;
        # luksName = "crypted-os";
      };

      data = {
        device = dataDevice;
        encrypted = true;
        # luksName = "crypted-data";
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

  my.services = {
    network = {
      enable = true;
      leiden.enable = true;
    };

    keyd.enable = true;
    audio.enable = true;
    wacom.enable = true;
    mullvad.enable = true;
  };

  users.mutableUsers = false;

  my.users = {
    louis = {
      enable = true;
      hm.enable = true;
    };
    root = {
      enable = true;
      hm.enable = true;
    };
  };

  networking.hostName = "T14p";

  programs.sway = {
    enable = true;
  };
  services.displayManager.gdm.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.enableAllFirmware = true;

  system.stateVersion = "25.11";
}
