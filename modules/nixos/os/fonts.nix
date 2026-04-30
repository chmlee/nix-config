{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.os.fonts;
in
{
  options.my.os.fonts = {
    enable = lib.mkEnableOption "enable fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      lxgw-fusionkai
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      winePackages.fonts
      noto-fonts-color-emoji
      nerd-fonts.fira-code
    ];
  };
}
