{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.my.home.apps.pi-coding-agent;
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  options.my.home.apps.pi-coding-agent = {
    enable = lib.mkEnableOption "pi coding agent";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ unstable.pi-coding-agent ];

    home.file.".pi/agent/models.json".text = builtins.toJSON {
      providers = {
        mistral = {
          baseUrl = "https://api.mistral.ai/v1";
          api = "openai-completions";
          apiKey = "$MISTRAL_API_KEY"; # or use /login instead
          models = [
            { id = "mistral-small-latest"; }
          ];
        };
      };
    };

    home.file.".pi/agent/settings.json".text = builtins.toJSON {
      # any pi settings here
    };
  };
}
