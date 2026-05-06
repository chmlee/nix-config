{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.users.louis;
in
{
  options.my.users.louis = {
    enable = lib.mkEnableOption "the louis user account";
    hm.enable = lib.mkEnableOption "Home Manager configuration for louis";
  };

  config = lib.mkIf cfg.enable {

    sops.secrets."users/louis/hashedPassword" = {
      neededForUsers = true;
    };

    users.users.louis = {
      isNormalUser = true;
      description = "Louis Chih-Ming Lee";
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "nixos-config"
      ];
      hashedPasswordFile = config.sops.secrets."users/louis/hashedPassword".path;
    };

    users.users.louis.shell = pkgs.zsh;
    programs.zsh.enable = true;

    home-manager.users.louis = lib.mkIf cfg.hm.enable {
      imports = [
        ./home.nix
      ];
    };
  };

}
