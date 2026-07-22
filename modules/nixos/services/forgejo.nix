{ lib, config, ... }:

let
  cfg = config.my.services.forgejo;

  httpPort = cfg.httpPort;
  sshPort = cfg.sshPort;
in
{
  options.my.services.forgejo = {
    enable = lib.mkEnableOption "Forgejo";

    domain = lib.mkOption {
      type = lib.types.str;
      example = "git.example.com";
    };

    httpPort = lib.mkOption {
      type = lib.types.port;
      default = 3000;
    };

    sshPort = lib.mkOption {
      type = lib.types.port;
      default = 2222;
    };

    acmeEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    disableRegistration = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    requireSignInView = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    my.services.postgresql = {
      enable = true;

      ensureDatabases = [
        "forgejo"
      ];

      ensureUsers = [
        {
          name = "forgejo";
          ensureDBOwnership = true;
        }
      ];
    };

    my.services.nginx = {
      enable = true;
      acmeEmail = cfg.acmeEmail;

      virtualHosts.${cfg.domain} = {
        forceSSL = true;
        enableACME = cfg.acmeEmail != null;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString httpPort}";
          proxyWebsockets = true;
        };
      };
    };

    environment.systemPackages = [
      config.services.forgejo.package
    ];

    services.forgejo = {
      enable = true;

      stateDir = "/persist/forgejo";  # All Forgejo runtime data goes here

      database = {
        type = "postgres";
        name = "forgejo";
        user = "forgejo";
        socket = "/run/postgresql";
      };

      settings = {
        server = {
          DOMAIN = cfg.domain;
          ROOT_URL = "https://${cfg.domain}/";

          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = httpPort;

          START_SSH_SERVER = true;
          SSH_PORT = sshPort;
          SSH_LISTEN_PORT = sshPort;
        };

        service = {
          DISABLE_REGISTRATION = cfg.disableRegistration;
          REQUIRE_SIGNIN_VIEW = cfg.requireSignInView;
        };

        session = {
          COOKIE_SECURE = true;
        };

        security = {
          INSTALL_LOCK = true;
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /persist/forgejo 0750 forgejo forgejo -"
    ];

    networking.firewall.allowedTCPPorts = [
      sshPort
    ];
  };
}
