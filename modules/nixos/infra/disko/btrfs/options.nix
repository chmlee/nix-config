{ lib, ... }:

let
  inherit (lib) mkEnableOption mkOption types;

  subvolumeNames = builtins.attrNames (import ./subvolumes.nix);
in
{
  options.my.infra.disko.btrfs = {
    enable = mkEnableOption "generic btrfs disko layout";

    topology = mkOption {
      type = types.enum [
        "dual-disk"
        "single-disk"
      ];
      default = "dual-disk";
      description = "Physical disk topology to generate.";
    };

    espSize = mkOption {
      type = types.str;
      default = "1G";
      description = "Size of the EFI system partition.";
    };

    disks = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            device = mkOption {
              type = types.str;
              description = "Block device path for this disk.";
              example = "/dev/disk/by-id/scsi-0HC_Volume_104473479";
            };

            encrypted = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to wrap this disk's main partition in LUKS.";
            };

            luksName = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                Optional LUKS mapper name when encryption is enabled.
                If null, defaults to "crypted-<diskName>" or "crypted-<filesystemName>".
              '';
            };
          };
        }
      );

      default = { };
      description = "Named physical disks used by the layout.";
    };

    filesystems = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            disk = mkOption {
              type = types.str;
              description = "Name of the disk this filesystem should live on.";
              example = "os";
            };

            subvolumes = mkOption {
              type = types.listOf (types.enum subvolumeNames);
              default = [ ];
              description = "Named btrfs subvolumes to include.";
            };

            encrypted = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = ''
                Optional per-filesystem encryption override.
                If null, inherit the encryption setting from the target disk.
              '';
            };

            luksName = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                Optional per-filesystem LUKS mapper name.
                If null, inherit the name from the target disk.
              '';
            };
          };
        }
      );

      default = { };
      description = "Named btrfs filesystems and their selected subvolumes.";
    };
  };
}
