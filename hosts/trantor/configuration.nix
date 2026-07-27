{
  modulesPath,
  lib,
  pkgs,
  ...
}:

let
  adminSshKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8hnz1WkRNCBybhR+FKJfxt/bxaMeqivBGSz55rIRr7 louis@T14p";
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/installer/scan/not-detected.nix")

    ./disk.nix
    ./box.nix
  ];

  networking = {
    hostName = "trantor";
    useDHCP = lib.mkDefault true;

    # Keep exposed ports explicit and auditable here.
    firewall.allowedTCPPorts = [
      22
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    btrfs-progs
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.openssh = {
    enable = true;

    # Port 22 is opened explicitly through networking.firewall above.
    openFirewall = false;
    ports = [ 22 ];

    settings = {
      PubkeyAuthentication = true;

      # Root may connect using your SSH key, but never a password.
      PermitRootLogin = "prohibit-password";

      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      # Some additional reasonable server defaults.
      X11Forwarding = false;
      AllowAgentForwarding = false;
    };
  };

  users.users.root = {
    # Disable password-based login for root.
    hashedPassword = "!";

    openssh.authorizedKeys.keys = [
      adminSshKey
    ];
  };

  my.infra.sops = {
    enable = true;
    defaultSopsFile = ../../secrets.yaml;
    ageKeyFile = "/persist/sops/key.txt";
  };

  boot.loader = {
    systemd-boot.enable = false;

    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };

    efi.canTouchEfiVariables = false;
  };

  boot.initrd.network = {
    enable = true;

    ssh = {
      enable = true;
      port = 2222;

      authorizedKeys = [
        adminSshKey
      ];

      hostKeys = [
        "/etc/ssh/initrd_ssh_host_ed25519_key"
      ];
    };
  };

  boot.kernelParams = [
    "ip=dhcp"
  ];

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
