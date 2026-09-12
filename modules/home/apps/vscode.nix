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
          # jk in insert mode sends <Esc>, matching the nvim config
          # (init.lua: vim.keymap.set('i', 'jk', '<Escape>')).
          "vscode-neovim.compositeKeys" = {
            "jk" = {
              command = "vscode-neovim.escape";
              args = [ ];
            };
          };

          "editor.lineNumbers" = "on";
          "editor.formatOnSave" = true;
          "editor.fontFamily" = "'FiraCode Nerd Font', monospace";
          "editor.fontSize" = 14;
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

          # Pin the vscode-neovim background process to a CPU affinity for speed.
          # Set here because VS Code can't write to the home-managed settings.json.
          "extensions.experimental.affinity" = {
            "asvetliakov.vscode-neovim" = 1;
          };
        };

        keybindings = [
          {
            key = "ctrl+j";
            command = "workbench.action.terminal.toggleTerminal";
            when = "terminalProcessSupported || webExtensionActivated";
          }

          # --- Jupyter notebook: browser-Jupyter-style cell navigation ---
          # Esc exits cell edit mode -> command mode (cell selected, not editing).
          {
            key = "escape";
            command = "notebook.cell.quitEdit";
            when = "inputFocus && notebookEditorFocused";
          }
          # Enter a selected cell to edit it.
          {
            key = "enter";
            command = "notebook.cell.edit";
            when = "notebookCellListFocused && notebookEditorFocused && !inputFocus";
          }
          # j / k move between cells in command mode (cursor not in a cell).
          {
            key = "j";
            command = "notebook.cell.navigateDown";
            when = "notebookEditorFocused && !inputFocus";
          }
          {
            key = "k";
            command = "notebook.cell.navigateUp";
            when = "notebookEditorFocused && !inputFocus";
          }
          # VS Code has no notebook.cell.navigate* command; the cell list is a list
          # widget, so use the generic list.down / list.up scoped to the notebook.
          {
            key = "j";
            command = "runCommands";
            args = {
              commands = [
                "notebook.focusNextEditor"
                "notebook.cell.quitEdit"
              ];
            };
            when = "notebookEditorFocused && !inputFocus";
          }
          {
            key = "k";
            command = "runCommands";
            args = {
              commands = [
                "notebook.focusPreviousEditor"
                "notebook.cell.quitEdit"
              ];
            };
            when = "notebookEditorFocused && !inputFocus";
          }
          # Shift+Enter: run cell and select the one below (browser Jupyter default).
          {
            key = "shift+enter";
            command = "notebook.cell.executeAndSelectBelow";
            when = "notebookCellListFocused && notebookCellType == 'code' && notebookKernelCount > 0";
          }
          # Ctrl+Enter: run cell and stay on it.
          {
            key = "ctrl+enter";
            command = "notebook.cell.execute";
            when = "notebookCellListFocused && notebookCellType == 'code' && notebookKernelCount > 0";
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
