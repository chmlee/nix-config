{ config, lib, pkgs, ... }:
{
  options = {
    my.home.apps.git.enable = lib.mkEnableOption "Enable custom Git configuration";
  };

  config = lib.mkIf config.my.home.apps.git.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Louis Chih-Ming Lee";
          email = "louis@louisclee.com";
        };
      };
    };
  };
}
