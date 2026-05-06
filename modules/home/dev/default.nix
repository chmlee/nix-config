{ pkgs, lib, config, ... }: {
  imports = [
    ./r
    ./python
  ];
}

# { pkgs, lib, config, ... }:
# let
#   my-r = pkgs.callPackage ./r.nix {};
#   my-python = pkgs.callPackage ./python.nix {};
#
#   cfg = config.my;
# in
# {
#   options.my = {
#     r.enable = lib.mkEnableOption "R language support with Jupyter and RStudio";
#     python.enable = lib.mkEnableOption "Python language support with Jupyter";
#   };
#
#   config = lib.mkMerge [
#     (lib.mkIf cfg.r.enable { 
#       home.packages = [
#         my-r.env
# 	my-r.rstudio
#       ];
#       xdg.dataFile."jupyter/kernels/ir-nix/kernel.json".text = builtins.toJSON {
#         argv = [
#           "${my-r.env}/bin/R"
# 	  # "/etc/profiles/per-user/louis/bin/R"
#           "--slave"
#           "-e"
#           "IRkernel::main()"
#           "--args"
#           "{connection_file}"
#         ];
#         display_name = "R (nix)";
#         language = "R";
#       };
#     })
#
#     # (lib.mkIf cfg.python.enable {
#     #   home.packages = [ my-python ];
#     #
#     #   # Define Python Kernel
# }
