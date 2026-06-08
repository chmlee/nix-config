{ lib, config, ... }:

let
  cfg = config.my.infra.disko.btrfs;
  builders = import ../builders.nix { inherit lib; };

  inherit (builders) mkBtrfs maybeLuks mkEsp;

  mkFsContent =
    fsName:
    let
      fs = cfg.filesystems.${fsName};
      disk = cfg.disks.${fs.disk};

      encrypted = if fs.encrypted == null then disk.encrypted else fs.encrypted;

      luksName =
        if fs.luksName != null then
          fs.luksName
        else if disk.luksName != null then
          disk.luksName
        else
          "crypted-${fsName}";
    in
    maybeLuks {
      inherit encrypted luksName;
      content = mkBtrfs fs.subvolumes;
    };
in
{
  config = lib.mkIf (cfg.enable && cfg.topology == "dual-disk") {
    disko.devices.disk = {
      os = {
        type = "disk";
        device = cfg.disks.os.device;

        content = {
          type = "gpt";

          partitions = {
            ESP = mkEsp cfg.espSize;

            os = {
              size = "100%";
              content = mkFsContent "os";
            };
          };
        };
      };

      data = {
        type = "disk";
        device = cfg.disks.data.device;

        content = {
          type = "gpt";

          partitions = {
            data = {
              size = "100%";
              content = mkFsContent "data";
            };
          };
        };
      };
    };
  };
}
