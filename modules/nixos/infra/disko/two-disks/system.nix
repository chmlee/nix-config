{ lib, config, ... }:
let
  cfg = config.my.infra.disko.twoDisk;
  maybeLuks =
    name: content:
    if cfg.encryption.enable then
      {
        type = "luks";
        inherit name content;
      }
    else
      content;

  esp = {
    size = cfg.espSize;
    type = "EF00";
    content = {
      type = "filesystem";
      format = "vfat";
      mountpoint = "/boot";
    };
  };

  btrfs = {
    type = "btrfs";
    subvolumes = {
      "@" = {
        mountpoint = "/";
      };

      "@nix" = {
        mountpoint = "/nix";
      };
    };
  };

in
  {
  config = lib.mkIf cfg.enable {
    disko.devices.disk.system = {
      type = "disk";
      device = cfg.systemDevice;
      content = {
        type = "gpt";
        partitions = {
          ESP = esp;

          luks = {
            size = "100%";
            content = maybeLuks cfg.systemLuksName btrfs;
          };
        };
      };
    };
  };
}
