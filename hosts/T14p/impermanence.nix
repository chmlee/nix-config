{ ... }:
{
  my.infra.impermanence = {
    enable = true;

    directories = [
      "/etc/nixos"
      # "/etc/ssh"
      "/var/lib/nixos"
      "/var/log/journal"
      "/var/lib/forgejo"

      # "/var/lib/nixos"
      # "/var/cache/nix"
      # "/var/lib/systemd/coredump"
      # "/var/lib/NetworkManager"
      # "/var/log/journal"
      # "/etc/NetworkManager/system-connections"
      # "/root/.config/sops/age"
    ];

    files = [
      "/etc/machine-id"
      # "/etc/ssh/initrd_ssh_host_ed25519_key"
    ];
  };
}
