{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  nvim-config-store = builtins.filterSource (path: type: baseNameOf path != "default.nix") ./.;
  nvim-config-files = builtins.attrNames (builtins.readDir nvim-config-store);
  nvim-config-lis = map (path: builtins.readFile "${nvim-config-store}/${path}") (nvim-config-files);
  nvim-config = builtins.concatStringsSep "\n" nvim-config-lis;

  cfg = config.my.home.apps.neovim;

  utftex = pkgs.stdenv.mkDerivation rec {
    pname = "libtexprintf";
    version = "1.27";
    src = pkgs.fetchFromGitHub {
      owner = "bartp5";
      repo = "libtexprintf";
      rev = "refs/tags/v${version}";
      hash = "sha256-5C3VZWxbxNHxQcQdeeHh/etwIqfqUed9kHvRf2TVilE=";
    };
    nativeBuildInputs = with pkgs; [
      autoreconfHook
      pkg-config
    ];
    buildInputs = [ pkgs.glib ];
    # binary is installed as `utftex`, which is what render-markdown.nvim calls
    meta.mainProgram = "utftex";
  };

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
        render-markdown-nvim
        plenary-nvim
        luasnip
        codecompanion-nvim
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

      initLua = nvim-config;

      extraPackages = with pkgs; [
        inotify-tools
        pyright
        basedpyright
        ltex-ls-plus
        utftex
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

      extraLuaPackages =
        p: with p; [
          magick
        ];

      extraPython3Packages =
        ps: with ps; [
          pynvim
          jupyter-client
          jupyter-cache
          python-lsp-server
          cairosvg
          pnglatex
          plotly
          pyperclip
          ipython
          nbformat
          pillow
        ];

      withRuby = true;
      withPython3 = true;
    };

    #sessionVariables = {
    #  EDITOR = "nvim";
    #  VISUAL = "nvim";
    #};
  };
}
