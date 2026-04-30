{ config, lib, ... }:

let
  cfg = config.my.home.dev.python;
in
lib.mkIf cfg.enable {
  xdg.dataFile."jupyter/kernels/python3/kernel.json".text = builtins.toJSON {
    argv = [
      "${cfg.package}/bin/python"
      "-m"
      "ipykernel_launcher"
      "-f"
      "{connection_file}"
    ];
    display_name = "Python";
    language = "python";
  };
}
