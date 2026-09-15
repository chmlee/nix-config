{ config, lib, pkgs, ... }:
{
  options = {
    my.home.apps.ssh.enable = lib.mkEnableOption "Enable custom SSH configuration";
    my.home.apps.ssh.liacsUsername = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Username for LIACS SSH access";
    };
  };

  config = lib.mkIf config.my.home.apps.ssh.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      extraConfig = lib.mkIf (config.my.home.apps.ssh.liacsUsername != null) ''
        Host idl2026
          HostName dm009a.student.liacs.nl
          User ${config.my.home.apps.ssh.liacsUsername}
          ProxyJump ${config.my.home.apps.ssh.liacsUsername}@ssh.liacs.nl
      '';
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
        };
      };
    };
  };
}
