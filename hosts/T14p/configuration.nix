{ ... }:
let
  stateDevice = "/dev/disk/by-id/nvme-WDBRPG0010BNC-WRSN_21034A800817";
  systemDevice = "/dev/disk/by-id/nvme-UMIS_RPJYJ1T24MML1AWQ_SS1D71533X1RC53B20DD";
in
{
  imports = [
    ./hardware.nix
  ];

  my.os = {
    core.enable = true;
    fonts.enable = true;

    virt = {
      enable = true;
      users = [ "louis" ];
    };
  };

  my.infra = {
    sops = {
      enable = true;
      defaultSopsFile = ../../secrets.yaml;
      ageKeyFile = "/persist/sops/key.txt";
    };
    disko.twoDisk = {
      enable = true;
      inherit stateDevice systemDevice;
    };
  };

  my.services = {
    network = {
      enable = true;
      leiden.enable = true;
    };

    keyd.enable = true;
    audio.enable = true;
    wacom.enable = true;

  };

  users.mutableUsers = false;

  my.users = {
    louis = {
      enable = true;
      hm.enable = true;
    };
    root = {
      enable = true;
      hm.enable = true;
    };
  };

  networking.hostName = "T14p";

  programs.sway = {
    enable = true;
  };
  services.displayManager.gdm.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.enableAllFirmware = true;

  system.stateVersion = "25.11";
}
