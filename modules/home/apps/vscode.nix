{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.home.apps.vscode;
in
{
  options.my.home.apps.vscode = {
    enable = lib.mkEnableOption "VS Code with the VSCode Neovim integration";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;

      # false => home-manager symlinks ~/.vscode/extensions to a nix-store buildEnv,
      # so extensions are reproducible and not clobbered by impermanence.
      mutableExtensionsDir = false;

      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          # Embeds a real neovim process inside VS Code for true vim keybindings
          # (not just emulation). Shares your nvim config; run clean here to avoid
          # GUI plugin conflicts (image/molten/nvim-tree) inside VS Code.
          asvetliakov.vscode-neovim
          # Jupyter notebook support: execution, renderers, and keymap.
          ms-toolsai.jupyter
          ms-toolsai.jupyter-keymap
          ms-toolsai.jupyter-renderers
          # Python language server, linting, and debugging.
          ms-python.python
        ];

        userSettings = {
          # Point the neovim extension at the nix-managed nvim binary.
          "vscode-neovim.neovimExecutablePaths.linux" = "${pkgs.neovim}/bin/nvim";
          # Run neovim --clean inside VS Code: pure keybindings, no plugin load.
          "vscode-neovim.neovimClean" = true;

          "editor.lineNumbers" = "relative";
          "editor.formatOnSave" = true;
          "editor.fontFamily" = "'FiraCode Nerd Font', monospace";
          "editor.fontSize" = 12;
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.rulers" = [
            80
          ];

          "workbench.colorTheme" = "Catppuccin Mocha";
          "workbench.iconTheme" = "catppuccin-mocha";
          "terminal.integrated.fontFamily" = "'FiraCode Nerd Font', monospace";

          "files.autoSave" = "afterDelay";
          "files.exclude" = {
            "**/.git" = true;
            "**/.svn" = true;
            "**/.hg" = true;
            "**/CVS" = true;
            "**/.DS_Store" = true;
          };
        };

        keybindings = [
          {
            key = "ctrl+j";
            command = "workbench.action.terminal.toggleTerminal";
            when = "terminalProcessSupported || webExtensionActivated";
          }
        ];
      };
    };

    home.persistence."/persist" = {
      directories = [
        ".vscode-server"
        ".config/Code"
        ".config/Code - OSS"
      ];
    };
  };
}
