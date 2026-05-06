{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    my.home.apps.starship.enable = lib.mkEnableOption "Enable custom starship configuration";
  };

  config = lib.mkIf config.my.home.apps.starship.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;

        nix_shell = {
          disabled = false;
          heuristic = true;
          symbol = "❄️ ";
          format = "[$symbol$name]($style) ";
          style = "bold blue";
        };

        scan_timeout = 100;
        command_timeout = 1000;

        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
        };
      };
    };
  };
}
