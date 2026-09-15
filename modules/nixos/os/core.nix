{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.os.core;
in
{
  options.my.os.core = {
    enable = lib.mkEnableOption "core OS settings (flakes, locale, base packages)";
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org/"
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        # "https://mirrors.ustc.edu.cn/nix-channels/store"
      ];
      extra-substituters = [ "https://pi.cachix.org" ];
      extra-trusted-public-keys = [
        "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
      ];
    };

    nixpkgs.config.allowUnfree = true;

    time.timeZone = "Europe/Amsterdam";
    # time.timeZone = "Asia/Taipei";

    environment.systemPackages = with pkgs; [
      vim
      git
      wget
      htop
      killall
      age
      sops
      acpi
      fzf
      libinput
      wdisplays
      wl-mirror
    ];

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      (lib.getLib gcc.cc.lib)
      (lib.getLib stdenv.cc.cc.lib)
    ];

    programs.git.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
