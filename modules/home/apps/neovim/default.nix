{ lib, config, pkgs, inputs,... }:
let
  nvim-config-store = builtins.filterSource (path: type: baseNameOf path != "default.nix") ./.;
  nvim-config-files = builtins.attrNames (builtins.readDir nvim-config-store);
  nvim-config-lis = map (path: builtins.readFile "${nvim-config-store}/${path}") (nvim-config-files);
  nvim-config = builtins.concatStringsSep "\n" nvim-config-lis;

  cfg = config.my.home.apps.neovim;

in
{
  options.my.home.apps.neovim = {
    enable = lib.mkEnableOption "nvim"; 
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;

      plugins = with pkgs.vimPlugins; [
        diffview-nvim
        nvim-treesitter.withAllGrammars
        nvim-lspconfig
        telescope-nvim
        nvim-cmp
        blink-cmp
        blink-compat
        cmp-nvim-lsp
        nvim-tree-lua
        which-key-nvim
        trouble-nvim
        kanagawa-nvim
        lazygit-nvim
        quarto-nvim
        otter-nvim
        image-nvim
        molten-nvim
        toggleterm-nvim
        markdown-preview-nvim
        vimtex
        lualine-nvim
        gitsigns-nvim
        indent-blankline-nvim
        guess-indent-nvim
        nvim-autopairs
        catppuccin-nvim
        jupytext-nvim
      ];

      extraLuaConfig = nvim-config;


      extraPackages = with pkgs; [
        #quarto
        inotify-tools
        pyright
        basedpyright
        python3Packages.python-lsp-server
        ripgrep
        lua-language-server
        rust-analyzer
        lazygit
        tectonic
        imagemagick
        jupyter
        pnglatex
        nil
        nixfmt

        rustc
        cargo
        rustfmt
        clippy
        rust-analyzer
      ];

      extraLuaPackages = p: with p; [
        magick
      ];

      extraPython3Packages = ps: with ps; [
        pynvim
        jupyter-client
        python-lsp-server
        cairosvg
        pnglatex
        plotly
        pyperclip
        ipython
        nbformat
      ];
    };

    #sessionVariables = {
    #  EDITOR = "nvim";
    #  VISUAL = "nvim";
    #};
  };
}
