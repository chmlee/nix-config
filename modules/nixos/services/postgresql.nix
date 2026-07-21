{ lib, config, ... }:

let
  cfg = config.my.services.postgresql;
in
{
  options.my.services.postgresql = {
    enable = lib.mkEnableOption "PostgreSQL";

    ensureDatabases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    ensureUsers = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      ensureDatabases = cfg.ensureDatabases;
      ensureUsers = cfg.ensureUsers;
    };
  };
}
