{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.my.home.apps.zellij;

  zellijPkg =
    if (inputs ? nixpkgs-unstable) then
      inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.zellij
    else
      pkgs.zellij;
in
{
  options.my.home.apps.zellij = {
    enable = lib.mkEnableOption "zellij session manager";
  };

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      package = zellijPkg;

      enableZshIntegration = true;

      settings = {
        default_shell = "${pkgs.zsh}/bin/zsh";

        # kitty graphics protocol support requires zellij >= 0.45.0
        support_kitty_graphics_protocol = true;

        # pane frames confuse image.nvim's window-offset math, so hide them
        pane_frames = false;
      };
    };
  };
}
