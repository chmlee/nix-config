{ pkgs, rPkgs }:

let
  rstudioWithPackages = pkgs.rstudioWrapper.override {
    packages = rPkgs;
  };
in
pkgs.symlinkJoin {
  name = "rstudio-wayland";
  paths = [ rstudioWithPackages ];
  buildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    mv $out/bin/rstudio $out/bin/rstudio-wayland

    wrapProgram $out/bin/rstudio-wayland \
      --add-flags "--ozone-platform=wayland" \
      --add-flags "--enable-features=WaylandWindowDecorations"
  '';
}
