{ lib, stdenv, cmake, gcc, python3, sdl2-compat, zlib, fetchFromGitHub, installPhase, cmakeFlags ? [ ] }:
let
  versionInfo = lib.importJSON ./version.json;
in
stdenv.mkDerivation {
  pname = "perfect-dark";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "fgsfdsfgs";
    repo = "perfect_dark";
    inherit (versionInfo) rev hash;
  };

  nativeBuildInputs = [
    cmake
    gcc
    python3
  ];

  # Disable warnings as errors since the project treats many warnings as fatal errors
  NIX_CFLAGS_COMPILE = "-Wno-error -Wno-macro-redefined -Wno-empty-body -Wno-format-security -Wno-implicit-const-int-float-conversion";

  buildInputs = [
    sdl2-compat
    zlib
  ];

  meta = with lib; {
    description = "Perfect Dark port to modern platforms";
    platforms = platforms.unix;
  };

  patches = [
    ../patches/0001-add-perfectdark-data-dir-env-support.patch
  ];

  inherit installPhase cmakeFlags;
}
