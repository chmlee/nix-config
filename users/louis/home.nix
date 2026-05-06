{
  config,
  pkgs,
  ...
}:
{
  home.username = "louis";
  home.homeDirectory = "/home/louis";
  home.stateVersion = "25.11";

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  my.home.apps = {
    starship.enable = true;
    zsh.enable = true;
    firefox.enable = true;
    neovim.enable = true;
    ssh.enable = true;
    git.enable = true;
    sway.enable = true;
    zotero.enable = true;
  };

  my.home.dev = {
    r.enable = true;
    python.enable = true;
  };

  home.sessionVariables = {
    # QUARTO_R = "/etc/profiles/per-user/louis/bin/R";
  };

  home.packages = with pkgs; [
    neofetch
    ranger
    lazygit
    audacity
    gzip
    poetry
    cmdstan
    stanc
    asciinema
    asciinema-agg
    vlc
    readest
    kdePackages.kate
    yt-dlp
    mpv
    youtube-tui
    joshuto
    unzip
    chromium
    pandoc
    libreoffice
    btop
    ripgrep-all
    rnote
    opentabletdriver
    xournalpp
    pdftk
    pcmanfm
    zathura
    sqlitebrowser
    kdePackages.okular
  ];

  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    documents = "${config.home.homeDirectory}/doc";
    download = "${config.home.homeDirectory}/down";
    pictures = "${config.home.homeDirectory}/pic";
    # extraConfig = "${config.home.homeDirectory}/.config";
  };

  home.persistence."/persist" = {
    directories = [
      "dev"
      "doc"
      "down"
      "pic"
      "test"
      "vm"
      "note"
      "music"
      ".ssh"

      ".local/share/jupyter/runtime" # needed for molten

      ".config/xournalpp"

      # steam related stuff
      ".steam"
      ".local/share/Steam"
    ];
    files = [
    ];
  };

  # programs.ssh = {
  #   enable = true;
  #   addKeysToAgent = "yes";
  # };

  # programs.git = {
  #   enable = true;
  #   userName = "Louis Chih-Ming Lee";
  #   userEmail = "louis@louisclee.com";
  # };

  programs.zsh = {
    enable = true;
  };

  services.ssh-agent.enable = true;

}
