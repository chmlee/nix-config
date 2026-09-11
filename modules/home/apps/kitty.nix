{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.home.apps.kitty;
in
{
  options.my.home.apps.kitty = {
    enable = lib.mkEnableOption "kitty terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      settings = {
        # graphics protocol is kitty's native feature, no flag needed;
        # keep it on (default) so molten/image.nvim can render plots
        font_family = "FiraCode Nerd Font";
        font_size = 8;

        confirm_os_window_close = 0;
        enable_audio_bell = false;

        # match the catppuccin mocha palette used elsewhere in this config
        background = "#1e1e2e";
        foreground = "#cdd6f4";

        color0 = "#45475a";
        color1 = "#f38ba8";
        color2 = "#a6e3a1";
        color3 = "#f9e2af";
        color4 = "#89b4fa";
        color5 = "#f5c2e7";
        color6 = "#94e2d5";
        color7 = "#bac2de";

        color8 = "#585b70";
        color9 = "#f38ba8";
        color10 = "#a6e3a1";
        color11 = "#f9e2af";
        color12 = "#89b4fa";
        color13 = "#f5c2e7";
        color14 = "#94e2d5";
        color15 = "#a6adc8";
      };
    };
  };
}
