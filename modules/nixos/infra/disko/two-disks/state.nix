{ lib, config, ... }:

let
  cfg = config.my.infra.disko.twoDisk;

  maybeLuks = name: content:
    if cfg.encryption.enable
    then {
      type = "luks";
      inherit name content;
    }
    else content;

  btrfs = {
    type = "btrfs";
    extraArgs = [ "-f" ];

    subvolumes = {
      "@persist" = {
        mountpoint = "/persist";
        mountOptions = [ "compress=zstd" "noatime" ];
      };

      "@data" = {
        mountpoint = "/mnt/data";
        mountOptions = [ "compress=zstd" "noatime" ];
      };

      "@db" = {
        mountpoint = "/var/lib/postgresql";
        mountOptions = [ "compress=no" "noatime" ];
      };
    };
  };
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
          content = maybeLuks cfg.stateLuksName btrfs;
        };
      };
    };
  };
}
