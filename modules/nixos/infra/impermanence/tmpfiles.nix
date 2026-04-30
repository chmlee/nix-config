{ ... }: {
  systemd.tmpfiles.rules = [
    "d /mnt/game 0755 users users -"
    "d /mnt/data 0755 users users -"
  ];
}
