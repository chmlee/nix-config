{ config, lib, ... }:

let
  cfg = config.my.services.immich;

  mediaRoot = "/box/immich";
  stateRoot = "/persist/immich";
in
{
  options.my.services.immich = {
    enable = lib.mkEnableOption "Immich";

    domain = lib.mkOption {
      type = lib.types.str;
      example = "photo.example.com";
    };

    acmeEmail = lib.mkOption {
      type = lib.types.str;
      example = "admin@example.com";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 2283;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.immich.uid = 900;
    users.groups.immich.gid = 900;

    services.immich = {
      enable = true;

      host = "127.0.0.1";
      port = cfg.port;

      mediaLocation = mediaRoot;

      redis.enable = true;

      database = {
        enable = true;
        createDB = true;
        user = "immich";
        name = "immich";
        host = "/run/postgresql";
      };

      machine-learning.enable = true;
    };

    systemd.tmpfiles.rules = [
      "d ${mediaRoot} 0750 immich immich -"
      "d ${mediaRoot}/library 0750 immich immich -"
      "d ${mediaRoot}/upload 0750 immich immich -"

      "d ${stateRoot} 0750 immich immich -"
      "d ${stateRoot}/thumbs 0750 immich immich -"
      "d ${stateRoot}/encoded-video 0750 immich immich -"
      "d ${stateRoot}/profile 0750 immich immich -"
      "d ${stateRoot}/backups 0750 immich immich -"
      "d ${stateRoot}/model-cache 0750 immich immich -"
    ];

    fileSystems = {
      "${mediaRoot}/thumbs" = {
        device = "${stateRoot}/thumbs";
        options = [ "bind" ];
      };

      "${mediaRoot}/encoded-video" = {
        device = "${stateRoot}/encoded-video";
        options = [ "bind" ];
      };

      "${mediaRoot}/profile" = {
        device = "${stateRoot}/profile";
        options = [ "bind" ];
      };

      "${mediaRoot}/backups" = {
        device = "${stateRoot}/backups";
        options = [ "bind" ];
      };
    };

    systemd.services.immich-server = {
      unitConfig.RequiresMountsFor = [
        mediaRoot
        "${mediaRoot}/thumbs"
        "${mediaRoot}/encoded-video"
        "${mediaRoot}/profile"
        "${mediaRoot}/backups"
        "/var/lib/postgresql"
      ];

      serviceConfig.DynamicUser = lib.mkForce false;
    };

    systemd.services.immich-machine-learning = {
      environment.MPLCONFIGDIR = "${stateRoot}/model-cache";

      serviceConfig = {
        CacheDirectory = lib.mkForce "";
        StateDirectory = lib.mkForce "";
        ReadWritePaths = [
          "${stateRoot}/model-cache"
        ];
      };
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        proxyWebsockets = true;

        extraConfig = ''
          client_max_body_size 50G;
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
        '';
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.acmeEmail;
    };
  };
}
