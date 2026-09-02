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

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 2048;
      cores = 2;
      graphics = false;
    };

    users.users.vmtest = {
      isNormalUser = true;
      initialPassword = "test";
      extraGroups = [ "wheel" ];
    };

    # Convenience for a disposable local test VM.
    security.sudo.wheelNeedsPassword = false;
  };
}
