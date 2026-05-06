{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.my.home.apps.firefox;
  ff-pkgs = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.my.home.apps.firefox.enable = lib.mkEnableOption "Firefox";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      nativeMessagingHosts = [
        pkgs.tridactyl-native
      ];

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;

        extensions.packages = with ff-pkgs; [
          ublock-origin
          tridactyl
          sponsorblock
          istilldontcareaboutcookies
          kagi-search
        ];

        search = {
          force = true;
          default = "kagi";

          engines = {
            "kagi" = {
              urls = [
                {
                  template = "https://kagi.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = [ "@k" ];
            };
          };
        };

        settings = {
          "browser.startup.homepage_welcome_url" = "";
          "browser.startup.homepage_welcome_url.additional" = "";
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.newtabpage.enabled" = false;
          "trailhead.firstrun.branches" = "nofirstrun";

          "browser.startup.homepage" = "kagi.com";
          "browser.disableResetPrompt" = true;

          "extensions.tridactyl.welcometabseen" = "true";
          "extensions.ublock0.adminSettings" = ''
            {"userSettings": {"welcomeDialogDismissed": true}}
          '';
          "extensions.sponsorblock.showInitialInjections" = false;

          "extensions.installation.enabled" = true;
          "extensions.autoDisableScopes" = 0;
          "extensions.enabledScopes" = 15;
          "extensions.startupScanScopes" = 15;
        };
      };
    };

    xdg.configFile."tridactyl/tridactylrc".text = ''
      set smoothscroll true
    '';

    home.persistence."/persist" = {
      files = [
        ".mozilla/firefox/default/key4.db" # Key database for wrappers
        ".mozilla/firefox/default/logins.json" # Encrypted passwords
        ".mozilla/firefox/default/cookies.sqlite" # Active session cookies
        ".mozilla/firefox/default/sessionstore.jsonlz4" # Open tabs and windows
        ".mozilla/firefox/default/cert9.db" # Certificate database (prevents SSL issues)
      ];
      directories = [
        ".mozilla/firefox/default/storage" # Required for many modern "Stay Logged In" tokens
      ];
    };
  };

}
