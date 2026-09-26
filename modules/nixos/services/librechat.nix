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

    # templated env file — exactly your eduroam pattern
    sops.templates."librechat.env" = {
      owner = "root";
      group = "root";
      mode = "0600";
      content = ''
        MISTRAL_API_KEY=${config.sops.placeholder.librechat_mistral_api_key}
      '';
    };

    # --- nix native container ---
    containers.librechat = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.11";

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
          nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "mongodb" ];

          services.librechat = {
            enable = true;
            enableLocalDB = true;
            # actual option name per your error message:
            credentialsFile = "/run/secrets/librechat.env";
          };

          networking.firewall.allowedTCPPorts = [ 3080 ];
          system.stateVersion = "26.06";
        };
    };
  };
}
