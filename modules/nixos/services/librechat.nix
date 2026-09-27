# hosts/common/services/librechat.nix
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.my.services.librechat;
in
{
  options.my.services.librechat = {
    enable = lib.mkEnableOption "LibreChat (self-hosted, nix native container)";
  };

  config = lib.mkIf cfg.enable {
    # --- secrets (host side, sops) ---
    sops.secrets.librechat_mistral_api_key = { };
    sops.secrets.librechat_jwt_secret = { };
    sops.secrets.librechat_jwt_refresh_secret = { };
    sops.secrets.librechat_creds_key = { };
    sops.secrets.librechat_creds_iv = { };

    # templated env file — exactly your eduroam pattern
    sops.templates."librechat.env" = {
      owner = "root";
      group = "root";
      mode = "0600";
      content = ''
        MISTRAL_API_KEY=${config.sops.placeholder.librechat_mistral_api_key}
        JWT_SECRET=${config.sops.placeholder.librechat_jwt_secret}
        JWT_REFRESH_SECRET=${config.sops.placeholder.librechat_jwt_refresh_secret}
        CREDS_KEY=${config.sops.placeholder.librechat_creds_key}
        CREDS_IV=${config.sops.placeholder.librechat_creds_iv}
        ALLOW_REGISTRATION=true
      '';
    };

    # --- nix native container ---
    containers.librechat = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.11";

      # inside containers.librechat.config
      networking.nameservers = [
        "8.8.8.8"
        "1.1.1.1"
      ];

      bindMounts = {
        # hand the rendered env file into the container, read-only
        "/run/secrets/librechat.env" = {
          hostPath = config.sops.templates."librechat.env".path;
          isReadOnly = true;
        };
      };

      config =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          nixpkgs.config.allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "mongodb"
              "mongodb-ce"
            ];

          services.librechat = {
            enable = true;
            enableLocalDB = true;
            # actual option name per your error message:
            credentialsFile = "/run/secrets/librechat.env";
            env.HOST = "0.0.0.0";
            settings = {
              version = "1.2.1"; # keep matching the module default — schema validation depends on the app build

              endpoints.custom = [
                {
                  name = "Mistral";
                  apiKey = "\${MISTRAL_API_KEY}";
                  baseURL = "https://api.mistral.ai/v1";
                  models = {
                    default = [
                      "mistral-large-latest"
                      "mistral-small-latest"
                      "codestral-latest"
                    ];
                    fetch = true;
                  };
                  titleConvo = true;
                  titleModel = "mistral-small-latest"; # correct key name
                  modelDisplayLabel = "Mistral";
                  # required by the Mistral API, else 422s:
                  dropParams = [
                    "stop"
                    "user"
                    "frequency_penalty"
                    "presence_penalty"
                  ];
                }
              ];
            };
          };

          services.mongodb = {
            enable = true;
            package = pkgs.mongodb-ce;
            bind_ip = "127.0.0.1"; # container-internal; LibreChat connects via localhost
          };

          networking.firewall.allowedTCPPorts = [ 3080 ];
          system.stateVersion = "26.06";
        };
    };
  };
}
