{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.services.mullvad;
in
{
  options.my.services.mullvad = {
    enable = lib.mkEnableOption "Enable Mullvad";
  };

  config = lib.mkIf cfg.enable {
    services.mullvad-vpn.enable = true;
    services.resolved.enable = true;
    environment.systemPackages = with pkgs; [
      mullvad-vpn
    ];

  };
}
