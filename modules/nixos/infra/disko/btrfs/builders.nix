{ lib }:

let
  registry = import ./subvolumes.nix;
in
{
  mkBtrfs = names: {
    type = "btrfs";
    extraArgs = [ "-f" ];
    subvolumes = builtins.listToAttrs
      (map
        (name:
          let
            sv = registry.${name};
          in
          {
            name = sv.name;
            value = {
              inherit (sv) mountpoint mountOptions;
            };
          })
        names);
  };

  maybeLuks = { encrypted, luksName, content }:
    if encrypted then {
      type = "luks";
      name = luksName;
      inherit content;
    } else content;

  mkEsp = espSize: {
    size = espSize;
    type = "EF00";
    content = {
      type = "filesystem";
      format = "vfat";
      mountpoint = "/boot";
    };
  };
}
