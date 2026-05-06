{ config, lib, ... }:
let
  cfg = config.my.home.dev.r;
in
lib.mkIf cfg.enable {
  xdg.dataFile."jupyter/kernels/ir-nix/kernel.json".text = builtins.toJSON {
    argv = [
      "${cfg.package}/bin/R"
      "--slave"
      "-e"
      "library(IRkernel); IRkernel::main()"
      "--args"
      "{connection_file}"
    ];
    display_name = "R (nix)";
    language = "R";
  };

  home.file.".Rprofile".text = ''
    options(jupyter.rich_display = FALSE)
  '';
}
