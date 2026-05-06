{ config, pkgs, lib, ... }:

let
  cfg = config.my.home.apps.fuzzel;
in
{
  options.my.home.apps.fuzzel = {
    enable = lib.mkEnableOption "Fuzzel launcher";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.fuzzel;
      defaultText = "pkgs.fuzzel";
      description = "Fuzzel package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
      pkgs.jetbrains-mono
    ];

    xdg.enable = true;

    # fuzzel uses ~/.config/fuzzel/fuzzel.ini
    xdg.configFile."fuzzel/fuzzel.ini".source = ./fuzzel.ini;
  };
}
