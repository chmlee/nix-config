{ config, lib, ... }:

let
  cfg = config.my.services.network.leiden;
in
{
  options.my.services.network.leiden = {
    enable = lib.mkEnableOption "Leiden University Eduroam profile";
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.wifi_leiden_identity = { };
    sops.secrets.wifi_leiden_password = { };
    
    sops.templates."wifi_eduroam.nmconnection" = {
      path = "/etc/NetworkManager/system-connections/eduroam.nmconnection";
      owner = "root";
      group = "root";
      mode = "0600";
      
      content = ''
        [connection]
        id=eduroam
        type=wifi
        
        [wifi]
        ssid=eduroam
        mode=infrastructure
        
        [wifi-security]
        key-mgmt=wpa-eap
        
        [802-1x]
        eap=peap
        identity=${config.sops.placeholder.wifi_leiden_identity}
        password=${config.sops.placeholder.wifi_leiden_password}
        anonymous-identity=anonymous@leidenuniv.nl
        phase2-auth=mschapv2
        ca-cert=${./leiden.crt}
      '';
    };
  };
}
