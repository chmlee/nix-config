{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.home.apps.zotero;
  syncZoteroScript = pkgs.writeShellScriptBin "zotero-sync-lib" ''
    ZOTERO_DIR="$HOME/Zotero/storage"
    LIB_DIR="$HOME/lib"

    mkdir -p "$LIB_DIR"
    echo "Syncing Zotero documents to $LIB_DIR..."

    # 1. Safely wipe all existing symlinks in the lib directory
    find "$LIB_DIR" -type l -delete

    # 2. Rebuild the directory from scratch
    find "$ZOTERO_DIR" -mindepth 2 -maxdepth 2 -type f \( -iname "*.pdf" -o -iname "*.epub" \) | while read -r filepath; do
        filename=$(basename "$filepath")
        folder_hash=$(basename "$(dirname "$filepath")")
        target_path="$LIB_DIR/$filename"

        # Collision check for identically named files
        if [ -e "$target_path" ]; then
            target_path="$LIB_DIR/''${folder_hash}_''${filename}"
        fi

        ln -s "$filepath" "$target_path"
    done
    echo "Done! Your library is completely up to date."
  '';
in
{
  options.my.home.apps.zotero = {
    enable = lib.mkEnableOption "Enable Zotero reference manager";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.zotero
      syncZoteroScript
      pkgs.sqlite
    ];

    home.persistence."/persist" = {
      directories = [
        "Zotero"
        ".zotero"
      ];
    };
  };
}
