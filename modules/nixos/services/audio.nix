{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.my.services.audio;
in
{
  options.my.services.audio = {
    enable = mkEnableOption "PipeWire-based audio configuration";
  };

  config = mkIf cfg.enable {

    # Disable PulseAudio
    services.pulseaudio.enable = false;

    # PipeWire setup
    services.pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;

      pulse.enable = true;
      jack.enable = true;
    };

    services.blueman.enable = true; # GUI manager (optional but helpful)

    # Useful audio tools
    environment.systemPackages = with pkgs; [
      pavucontrol
      alsa-utils
      pamixer
      playerctl
    ];
  };
}
