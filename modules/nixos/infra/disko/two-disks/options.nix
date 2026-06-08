{ lib, ... }:
{
  options.my.infra.disko.twoDisk = {
    enable = lib.mkEnableOption "Two-disk Disko layout (system + state)";

    systemDevice = lib.mkOption {
      type = lib.types.str;
      example = "/dev/disk/by-id/nvme-...";
      description = "Device path for the system disk";
    };

    stateDevice = lib.mkOption {
      type = lib.types.str;
      example = "/dev/disk/by-id/nvme-...";
      description = "Device path for the state disk";
    };

    espSize = lib.mkOption {
      type = lib.types.str;
      default = "512M";
      description = "Size of the EFI System Partition.";
    };

    encryption = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to wrap both system and state disks in LUKS.";
      };
    };

    systemLuksName = lib.mkOption {
      type = lib.types.str;
      default = "crypt-system";
    };

    stateLuksName = lib.mkOption {
      type = lib.types.str;
      default = "crypt-state";
    };

  };
}
