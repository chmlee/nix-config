{ lib, config, ... }:
let
  cfg = config.my.infra.disko.twoDisk;
in
{
  config = lib.mkIf cfg.enable {
    disko.devices.disk.system = {
      type = "disk";
      device = cfg.systemDevice;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = cfg.espSize;
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = cfg.systemLuksName;
              content = {
                type = "btrfs";
                subvolumes = {
                  "@" = { mountpoint = "/"; };
                  "@nix" = { mountpoint = "/nix"; };
                };
              };
            };
          };
        };
      };
    };
  };
}
