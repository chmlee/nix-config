{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.home.dev.python;
in
{
  imports = [ ./kernel.nix ];

  options.my.home.dev.python = {
    enable = lib.mkEnableOption "Python development environment";

    package = lib.mkOption {
      type = lib.types.package;
      internal = true;
      description = "The compiled Python environment to share across modules";
    };
  };

  config = lib.mkIf cfg.enable {
    my.home.dev.python.package = import ./env.nix { inherit pkgs; };

    home.packages = [ cfg.package ];
  };
}
