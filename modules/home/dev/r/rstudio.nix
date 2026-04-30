{ pkgs, rPkgs }:
pkgs.rstudioWrapper.override {
  packages = rPkgs;
}
