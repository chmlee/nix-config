{ config, lib, pkgs, trantorProfile, ... }:

let
  isVm = trantorProfile == "vm";
  boxPath = "/box";
in
{
  sops.secrets."trantor/box/credentials" = {
    mode = "0400";
  };

  environment.systemPackages =
    lib.optionals (!isVm) [ pkgs.cifs-utils ];

  # In the VM, /box is just a local directory.
  systemd.tmpfiles.rules = lib.optionals isVm [
    "d ${boxPath} 0770 900 900 -"
  ];

  # In production, /box is mounted from Hetzner Storage Box.
  fileSystems.${boxPath} = lib.mkIf (!isVm) {
    device = "//u536222.your-storagebox.de/backup";
    fsType = "cifs";

    options = [
      "_netdev"
      "nofail"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=10min"
      "x-systemd.mount-timeout=30s"

      "credentials=${config.sops.secrets."trantor/box/credentials".path}"

      "rw"
      "noperm"
      "uid=900"
      "gid=900"
      "forceuid"
      "forcegid"
      "file_mode=0660"
      "dir_mode=0770"
      "vers=3.1.1"
    ];
  };
}
