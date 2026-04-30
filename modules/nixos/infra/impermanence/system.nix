{ ... }: {
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    enable = true;  # NB: Defaults to true, not needed
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/etc/ssh"
      #"/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"

      "/var/cache/nix"

      "/var/lib/systemd/coredump"
      "/var/lib/NetworkManager"
      "/var/log/jounral"
      "/etc/NetworkManager/system-connections"
      "/root/.config/sops/age"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
