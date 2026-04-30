{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.wacom;
in
{
  options.my.services.wacom = {
    enable = lib.mkEnableOption "Enable wacom related config";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.wacom.enable = true;
  };
}
