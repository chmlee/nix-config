{ lib, config, ... }:

let
  cfg = config.my.infra.disko.btrfs;
  builders = import ../builders.nix { inherit lib; };

  inherit (builders) mkBtrfs maybeLuks mkEsp;

  fs = cfg.filesystems.os;
  disk = cfg.disks.${fs.disk};

  encrypted = if fs.encrypted == null then disk.encrypted else fs.encrypted;

  luksName =
    if fs.luksName != null then
      fs.luksName
    else if disk.luksName != null then
      disk.luksName
    else
      "crypted-os";

  keyFile = disk.keyFile;

  fsContent = maybeLuks {
    inherit encrypted luksName keyFile;
    content = mkBtrfs fs.subvolumes;
  };
in
{
  config = lib.mkIf (cfg.enable && cfg.topology == "single-disk") {
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
              content = fsContent;
            };
          };
        };
      };
    };
  };
}
