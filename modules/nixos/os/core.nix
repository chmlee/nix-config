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
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nixpkgs.config.allowUnfree = true;

    time.timeZone = "Europe/Amsterdam";

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
