{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.home.dev.r;
  rPkgs = import ./packages.nix { inherit pkgs; };
  cmdstanDir = "${config.xdg.dataHome}/cmdstan-${pkgs.cmdstan.version}";
  quartoPkgs = import inputs.quarto-nixpkgs {
    system = pkgs.system;
  };
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
      # quarto
      quartoPkgs.quarto
      pandoc
      graphviz
      texliveFull

      # CmdStan dependencies
      cmdstan
      gnumake
      gcc
    ];

    home.sessionVariables = {
      QUARTO_R = "${cfg.package}/bin/R";
    };

    home.file.".Renviron".text = ''
      CMDSTAN=${cmdstanDir}
    '';

    home.activation.installCmdstan = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      target="${cmdstanDir}"

      if [ ! -d "$target" ]; then
        ${pkgs.coreutils}/bin/mkdir -p "${config.xdg.dataHome}"
        ${pkgs.coreutils}/bin/cp -R \
          "${pkgs.cmdstan}/opt/cmdstan" \
          "$target"
        ${pkgs.coreutils}/bin/chmod -R u+w "$target"
      fi
    '';
  };
}
