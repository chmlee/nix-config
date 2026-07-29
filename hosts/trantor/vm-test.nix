{ lib, ... }:

{
  imports = [
    ./init.nix
    ./disk/system-vm.nix
  ];

  # The smoke-test disk is unencrypted, so stage-1 networking and SSH are
  # unnecessary.
  boot.initrd.network.ssh.enable = lib.mkForce false;
  boot.initrd.systemd.network.enable = lib.mkForce false;
}
