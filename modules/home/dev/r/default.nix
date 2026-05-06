{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.home.dev.r;
  rPkgs = import ./packages.nix { inherit pkgs; };
in
{
  imports = [ ./kernel.nix ];

  options.my.home.dev.r = {
    enable = lib.mkEnableOption "R development environment";

    package = lib.mkOption {
      type = lib.types.package;
      internal = true;
      description = "The compiled R environment to share across modules";
    };
  };

  config = lib.mkIf cfg.enable {
    my.home.dev.r.package = import ./env.nix { inherit pkgs rPkgs; };

    home.packages = with pkgs; [
      cfg.package
      (import ./rstudio.nix { inherit pkgs rPkgs; })
      quarto
      graphviz
      texliveFull
    ];

    home.sessionVariables = {
      QUARTO_R = "${cfg.package}/bin/R";
    };
  };
}
