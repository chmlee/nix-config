{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.services.keyd;
in
{
  options.my.services.keyd = {
    enable = lib.mkEnableOption "keyboard remapping";
  };

  config = lib.mkIf cfg.enable {
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "layer(control)";
              control = "capslock";
              leftmeta = "layer(alt)";
              leftalt = "layer(meta)";
              rightalt = "esc";
            };
          };
        };
        hhkb = {
          ids = [ "04fe:0021:f2a164d2" ];
          settings = { };
        };
      };
    };
  };
}
