{
  config,
  pkgs,
  ...
}:
let
in
{
    home.username = "root";

    home.enableNixpkgsReleaseCheck = false;

    my.home.apps.neovim.enable = true;

    my.home.apps.git.enable = true;

    home.stateVersion = "25.11";

}
