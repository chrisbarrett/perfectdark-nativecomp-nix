{ pkgs }: pkgs.mkShell {
  buildInputs = with pkgs; [
    sdl2-compat
    cmake
    gcc
    python3
    zlib
    git
  ];
}
