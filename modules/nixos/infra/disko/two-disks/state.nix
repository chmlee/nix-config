{ lib, config, ... }:
let
  cfg = config.my.infra.disko.twoDisk;
in
{
  config = lib.mkIf cfg.enable {
    disko.devices.disk.state = {
      type = "disk";
      device = cfg.stateDevice;
      content = {
        type = "gpt";
        partitions.luks = {
          name = "luks-state";
          size = "100%";
          content = {
            type = "luks";
            name = cfg.stateLuksName;

            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };

                "@data" = {
                  mountpoint = "/mnt/data";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };

                "@db" = {
                  mountpoint = "/var/lib/postgresql";
                  mountOptions = [
                    "compress=no"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
