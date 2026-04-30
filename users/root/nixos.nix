{ config, lib, ... }:

let
  cfg = config.my.users.root;
in
{
  options.my.users.root = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Home Manager configuration for root";
    };
    hm.enable = lib.mkEnableOption "Home Manager configuration for root";
  };

  config = lib.mkIf cfg.enable {

    users.users.root = {
      initialPassword = "password";
      # hashedPasswordFile = config.sops.secrets."users/root/hashedPassword".path;
    };

    # 3. Bind to Home Manager (Optional for root, but good to have the toggle)
    home-manager.users.root = lib.mkIf cfg.hm.enable {
      imports = [
        ./home.nix
      ];
    };
  };
}
