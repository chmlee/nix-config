{
  root = {
    name = "@";
    mountpoint = "/";
    mountOptions = [ "compress=zstd" "noatime" ];
  };

  nix = {
    name = "@nix";
    mountpoint = "/nix";
    mountOptions = [ "compress=zstd" "noatime" ];
  };

  persist = {
    name = "@persist";
    mountpoint = "/persist";
    mountOptions = [ "compress=zstd" "noatime" ];
  };

  data = {
    name = "@data";
    mountpoint = "/mnt/data";
    mountOptions = [ "compress=zstd" "noatime" ];
  };

  postgresql = {
    name = "@db";
    mountpoint = "/var/lib/postgresql";
    mountOptions = [ "compress=no" "noatime" ];
  };

  containers = {
    name = "@containers";
    mountpoint = "/var/lib/containers";
    mountOptions = [ "compress=zstd" "noatime" ];
  };

  immich = {
    name = "@immich";
    mountpoint = "/var/lib/immich";
    mountOptions = [ "compress=zstd" "noatime" ];
  };
}
