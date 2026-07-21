{ lib, config, ... }:

let
  cfg = config.my.services.nginx;
in
{
  options.my.services.nginx = {
    enable = lib.mkEnableOption "nginx";

    virtualHosts = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
    };

    acmeEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts = cfg.virtualHosts;
    };

    security.acme = lib.mkIf (cfg.acmeEmail != null) {
      acceptTerms = true;
      defaults.email = cfg.acmeEmail;
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
