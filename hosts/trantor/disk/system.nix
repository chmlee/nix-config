{ lib, ... }:

let
  # Stable production identifier for Trantor's disposable system disk.
  #
  # This is deliberately a /dev/disk/by-id path rather than /dev/sda,
  # because kernel-assigned device names can change.
  systemDisk =
    "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_120278671";

  # Temporary path used only during installation.
  #
  # nixos-anywhere uploads the LUKS passphrase here before Disko formats
  # the disk. The installed system does not retain this file.
  installLuksPasswordFile = "/tmp/disko-os.key";

  # Common policy for all system-disk Btrfs subvolume mounts.
  btrfsMountOptions = [
    "compress=zstd:3"
    "noatime"
  ];
in
{
  disko.devices.disk.system = {
    type = "disk";

    # A VM-specific module can override this with /dev/vda without adding
    # VM conditionals to the production disk definition.
    device = lib.mkDefault systemDisk;

    content = {
      type = "gpt";

      partitions = {
        # GRUB embedding partition for legacy BIOS boot from a GPT disk.
        #
        # It has no filesystem and is never mounted.
        bios = {
          priority = 1;
          size = "1M";
          type = "EF02";
        };

        # EFI System Partition used when booting through UEFI.
        ESP = {
          priority = 2;
          size = "1G";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";

            # FAT has no Unix ownership or permission metadata, so access
            # restrictions are applied when the filesystem is mounted.
            mountOptions = [
              "umask=0077"
            ];
          };
        };

        # All remaining disk space is encrypted and used by Btrfs.
        system = {
          priority = 3;
          size = "100%";

          content = {
            type = "luks";
            name = "trantor-system";

            # Make the intended boot behavior explicit: Disko should generate
            # a boot.initrd.luks.devices entry for this encrypted device.
            initrdUnlock = true;

            # Used only to create and open the LUKS container during the
            # Disko/nixos-anywhere installation.
            passwordFile = installLuksPasswordFile;

            content = {
              type = "btrfs";

              extraArgs = [
                "-f"
                "-L"
                "trantor-system"
              ];

              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = btrfsMountOptions;
                };

                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = btrfsMountOptions;
                };
              };
            };
          };
        };
      };
    };
  };
}
