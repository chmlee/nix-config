{ ... }:
{
  users.groups.nixos-config = { };

  systemd.tmpfiles.rules = [
    "d /etc/nixos 2775 root nixos-config - -"
  ];

  programs.git = {
    config = {
      safe.directory = [ "/etc/nixos" ];
    };
  };
}
