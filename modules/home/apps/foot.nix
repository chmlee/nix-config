{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "FiraCode nerd Font:size=8";
        dpi-aware = "yes";
        pad = "6x6 center";
      };

      scrollback = {
        lines = 10000;
      };

      mouse = {
        hide-when-typing = "yes";
      };

      colors = {
        alpha = 0.95;

        background = "1e1e2e";
        foreground = "cdd6f4";

        regular0 = "45475A"; # black
        regular1 = "F38BA8"; # red
        regular2 = "A6E3A1"; # green
        regular3 = "F9E2AF"; # yellow
        regular4 = "89B4FA"; # blue
        regular5 = "F5C2E7"; # magenta
        regular6 = "94E2D5"; # cyan
        regular7 = "BAC2DE"; # white

        bright0 = "585B70";
        bright1 = "F38BA8";
        bright2 = "A6E3A1";
        bright3 = "F9E2AF";
        bright4 = "89B4FA";
        bright5 = "F5C2E7";
        bright6 = "94E2D5";
        bright7 = "A6ADC8";
      };
    };
  };
}
