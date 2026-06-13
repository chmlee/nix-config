{ lib, config, ... }:

let
  cfg = config.my.infra.impermanence;
in
{
  options.my.infra.impermanence = {
    enable = lib.mkEnableOption "impermanence";

    persistPath = lib.mkOption {
      type = lib.types.str;
      default = "/persist";
      description = "Path of the persistent filesystem.";
    };

    hideMounts = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    files = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems.${cfg.persistPath}.neededForBoot = true;

    environment.persistence.${cfg.persistPath} = {
      enable = true;
      hideMounts = cfg.hideMounts;
      directories = cfg.directories;
      files = cfg.files;
    };
  };
}
