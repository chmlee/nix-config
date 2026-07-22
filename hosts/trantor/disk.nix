{ trantorProfile, ... }:

let
  isVm = trantorProfile == "vm";

  osSubvolumes = [
    "root"
    "nix"
  ];

  dataSubvolumes = [
    "persist"
    "data"
    "postgresql"
  ];

  allSubvolumes = osSubvolumes ++ dataSubvolumes;

  prodOsDevice = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_120278671";
  prodDataDevice = "/dev/disk/by-id/scsi-0HC_Volume_104473479";

  vmDevice = "/dev/vda";
in
{
  assertions = [
    {
      assertion = builtins.elem trantorProfile [ "prod" "vm" ];
      message = "trantorProfile must be either \"prod\" or \"vm\".";
    }
  ];

  my.infra.disko.btrfs = {
    enable = true;
    topology = if isVm then "single-disk" else "dual-disk";

    disks =
      if isVm then {
        os = {
          device = vmDevice;
          encrypted = false;
        };
      } else {
        os = {
          device = prodOsDevice;
          encrypted = true;
          keyFile = "/tmp/disko-os.key";
        };

        data = {
          device = prodDataDevice;
          encrypted = true;
          keyFile = "/tmp/disko-data.key";
        };
      };

    filesystems =
      if isVm then {
        os = {
          disk = "os";
          subvolumes = allSubvolumes;
        };
      } else {
        os = {
          disk = "os";
          subvolumes = osSubvolumes;
        };

        data = {
          disk = "data";
          subvolumes = dataSubvolumes;
        };
      };
  };
}
