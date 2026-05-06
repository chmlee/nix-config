{ config, lib, pkgs, ... }:
{
  options = {
    my.home.apps.ssh.enable = lib.mkEnableOption "Enable custom SSH configuration";
  };

  config = lib.mkIf config.my.home.apps.ssh.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
        };
      };
    };
  };
}
