{ pkgs }:

let
  r = pkgs.rPackages;
in
r.buildRPackage rec {
  pname = "cmdstanr";
  version = "0.9.0";

  src = pkgs.fetchurl {
    url = "https://stan-dev.r-universe.dev/src/contrib/cmdstanr_${version}.tar.gz";
    hash = "sha256-5UHMvhg6sg24C0AVEAOVAPzMFnTnoyv2nVsKXmpK174=";
  };

  propagatedBuildInputs = with r; [
    checkmate
    data_table
    jsonlite
    posterior
    processx
    R6
    withr
    rlang
  ];
}
