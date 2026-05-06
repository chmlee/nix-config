{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.home.apps.sway;

  mod = "Mod4";

  terminal = "${pkgs.foot}/bin/foot";
  menu = "${pkgs.fuzzel}/bin/fuzzel";

  pactl = "${pkgs.pulseaudio}/bin/pactl";
  light = "${pkgs.brightnessctl}/bin/brightnessctl";
  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
  wlcopy = "${pkgs.wl-clipboard}/bin/wl-copy";

  colors = {
    base = "#1e1e2e";
    surface0 = "#313244";
    surface1 = "#45475a";

    text = "#cdd6f4";
    subtext = "#bac2de";

    blue = "#89b4fa";
    yellow = "#f9e2af";
    peach = "#fab387";
    red = "#f38ba8";
  };
in
{
  options.my.home.apps.sway = {
    enable = lib.mkEnableOption "sway";
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      pulseaudio
      brightnessctl
      # grim
      # slurp
      wl-clipboard
    ];

    wayland.windowManager.sway = {
      enable = true;

      config = {
        modifier = mod;
        terminal = terminal;
        menu = menu;
        bars = [ ];

        fonts = {
          names = [ "sans-serif" ];
          size = 10.0;
        };

        window = {
          border = 3;
          titlebar = false;
        };

        gaps = {
          inner = 0;
          outer = 0;
          smartGaps = false;
          smartBorders = "on";
        };

        colors = {
          focused = {
            border = colors.yellow;
            background = colors.yellow;
            text = colors.base;
            indicator = colors.yellow;
            childBorder = colors.yellow;
          };

          focusedInactive = {
            border = colors.surface1;
            background = colors.surface1;
            text = colors.text;
            indicator = colors.surface1;
            childBorder = colors.surface1;
          };

          unfocused = {
            border = colors.surface1;
            background = colors.surface1;
            text = colors.text;
            indicator = colors.surface1;
            childBorder = colors.surface1;
          };

          urgent = {
            border = colors.red;
            background = colors.red;
            text = colors.base;
            indicator = colors.red;
            childBorder = colors.red;
          };
        };

        keybindings = lib.mkOptionDefault {
          # launcher
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+d" = "exec ${menu}";

          # basic
          "${mod}+Shift+q" = "kill";
          "${mod}+Shift+r" = "reload";
          "${mod}+Shift+e" = "exec swaynag -t warning -m 'Exit sway?' -b 'Yes, exit' 'swaymsg exit'";

          # focus movement
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          # move windows
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          # split/layout
          "${mod}+b" = "splith";
          "${mod}+v" = "splitv";
          "${mod}+e" = "layout toggle split";
          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+a" = "focus parent";
          "${mod}+space" = "floating toggle";
          "${mod}+Shift+i" = "move scratchpad";
          "${mod}+i" = "scratchpad show";

          # workspaces 1..10
          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";

          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";

          # screenshots
          "Print" = "exec ${grim} - | ${wlcopy}";
          "Shift+Print" = "exec ${grim} -g \"$(${slurp})\" - | ${wlcopy}";

          # audio keys
          "XF86AudioRaiseVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";

          # brightness keys
          "XF86MonBrightnessUp" = "exec ${light} set +5%";
          "XF86MonBrightnessDown" = "exec ${light} set 5%-";
        };

        startup = [];
      };
    };
  };
}
