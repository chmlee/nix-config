{ ... }:
{
  my.infra.impermanence = {
    enable = true;

    directories = [
      "/etc/ssh"
      "/var/lib/nixos"
      "/var/log/journal"
      "/var/lib/acme"
      "/var/lib/nginx"
      "/var/lib/forgejo"
      "/root/.config/sops/age"
    ];

    files = [
      "/etc/machine-id"
    ];
  };
}
