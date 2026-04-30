{ config, lib, pkgs, ... }: let
  system-disk = "/dev/mapper/crypt-system";
in
{
  boot.initrd.supportedFilesystems = [ "btrfs" ];
  boot.initrd.postResumeCommands = lib.mkAfter ''
      mkdir -p /mnt
      mount -t btrfs ${system-disk} /mnt

      # delete older root backups
      if [[ -e /mnt/@ ]]; then
          mkdir -p /mnt/old_roots
          timestamp=$(date --date="@$(stat -c %Y /mnt/@)" "+%Y-%m-%d_%H-%M-%S")
          mv /mnt/@ "/mnt/old_roots/@-backup-$timestamp"
      fi

      # create empty root subvolume
      btrfs subvolume create /mnt/@

      umount /mnt
  '';
}
