{ pkgs, rPkgs }:
pkgs.rWrapper.override {
  packages = rPkgs;
}
