{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.home.apps.yazi;
in
{
  options.my.home.apps.yazi = {
    enable = lib.mkEnableOption "Enable yazi file manager";
  };

  config = lib.mkIf cfg.enable {
  };
}
