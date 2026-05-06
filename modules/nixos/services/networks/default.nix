{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.services.network;
in
{
  imports = [
    ./leiden.nix
  ];

  options.my.services.network = {
    enable = lib.mkEnableOption "NetworkManager and core network settings";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    programs.mtr.enable = true;
    services.openssh.enable = true;

    # Run nmcli reload after every switch
    system.activationScripts.nm-reload = {
      text = ''
        ${pkgs.networkmanager}/bin/nmcli connection reload || true
      '';
      deps = [ ];
    };
  };
}
