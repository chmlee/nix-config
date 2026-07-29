{ lib, ... }:

let
  btrfsMountOptions = [
    "compress=zstd:3"
    "noatime"
  ];
in
{
  # Replace the complete production disk declaration.
  #
  # The production definition is GPT → LUKS → Btrfs. This first smoke test
  # deliberately uses GPT → Btrfs so that the VM can reboot unattended.
  disko.devices.disk.system = lib.mkForce {
    type = "disk";
    device = "/dev/vda";

    content = {
      type = "gpt";

      partitions = {
        bios = {
          priority = 1;
          size = "1M";
          type = "EF02";
        };

        ESP = {
          priority = 2;
          size = "1G";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";

            mountOptions = [
              "umask=0077"
            ];
          };
        };

        system = {
          priority = 3;
          size = "100%";

          content = {
            type = "btrfs";

            extraArgs = [
              "-f"
              "-L"
              "trantor-system-test"
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
}
