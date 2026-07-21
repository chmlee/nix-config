{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk.nix
    ./impermanence.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    btrfs-progs
  ];

  networking.hostName = "trantor";
  networking.useDHCP = lib.mkDefault true;

  # my.os.core.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.openssh = {
    enable = true;
    openFirewall = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8hnz1WkRNCBybhR+FKJfxt/bxaMeqivBGSz55rIRr7 louis@T14p"
    ];
  };
  users.users.root.initialPassword = "changeme";

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = false;
  boot.initrd.network = {
    enable = true;

    ssh = {
      enable = true;
      port = 2222;

      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8hnz1WkRNCBybhR+FKJfxt/bxaMeqivBGSz55rIRr7 louis@T14p"
      ];

      hostKeys = [
        "/etc/ssh/initrd_ssh_host_ed25519_key"
      ];
    };
  };

  boot.kernelParams = [ "ip=dhcp" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "25.11";

  my.services.forgejo = {
    enable = true;
    domain = "git.louisclee.com";
    acmeEmail = "louis@louisclee.com";
    httpPort = 3000;
    sshPort = 22222;
  };

}
