{ lib, config, ... }:
let
  cfg = config.my.infra.sops;
in
{
  options.my.infra.sops = {
    enable = lib.mkEnableOption "sops-nix integration";

    ageKeyFile = lib.mkOption {
      type = lib.types.str;
      example = "/persist/sops/key.txt";
      description = "Path to the age key file used by sops-nix (persist this with impermanence).";
    };

    defaultSopsFile = lib.mkOption {
      type = lib.types.path;
      # default = ../../../../secrets.yaml;
      description = "Default SOPS file used by sops-nix.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.defaultSopsFile = cfg.defaultSopsFile;
    sops.age.keyFile = cfg.ageKeyFile;

    # sops.secrets."users/louis/hashedPassword" = {
    #   neededForUsers = true;
    #   owner = "root";
    #   group = "root";
    #   mode = "0400";
    # };
  };
}
