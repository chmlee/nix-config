{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    my.home.apps.zsh.enable = lib.mkEnableOption "Enable custom zsh configuration";
  };

  config = lib.mkIf config.my.home.apps.zsh.enable {
    programs.zsh = {
      enable = true;
      defaultKeymap = "viins";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 10000;
        save = 10000;
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
      };

      shellAliases = {
        ":q" = "exit";
      };

      initContent = ''
        # Reduce the escape key delay to 0.1 seconds
        export KEYTIMEOUT=10

        bindkey -v
        bindkey -M viins 'jk' vi-cmd-mode
        bindkey -M viins 'kj' vi-cmd-mode

        # Allow editing the current command line in Neovim
        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey -M vicmd 'v' edit-command-line
      '';
    };
    # sessionVariables = {
    #  QUARTO_R = "/home/louis/.nix-profile/bin/R";
    # };
  };
}
