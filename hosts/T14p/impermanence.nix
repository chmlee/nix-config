{ ... }:
{
  my.infra.impermanence = {
    enable = true;

    directories = [
      "/etc/nixos"
      "/etc/ssh"

      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/cache/nix"
      "/var/lib/systemd/coredump"
      "/var/lib/NetworkManager"
      "/var/log/journal"
      "/etc/NetworkManager/system-connections"
      "/root/.config/sops/age"
    ];

    files = [
      "/etc/machine-id"
    ];
  };
}
