{ pkgs, stdenv }: pkgs.callPackage ./builder.nix {
  cmakeFlags = [
    "-DCMAKE_SYSTEM_PROCESSOR=${stdenv.hostPlatform.parsed.cpu.name}"
  ] ++ pkgs.lib.optionals stdenv.hostPlatform.isx86_64 [
    "-DCMAKE_C_FLAGS=-m64"
    "-DCMAKE_CXX_FLAGS=-m64"
  ] ++ pkgs.lib.optionals stdenv.hostPlatform.isi686 [
    "-DCMAKE_C_FLAGS=-m32"
    "-DCMAKE_CXX_FLAGS=-m32"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp pd.* $out/bin/pd
    chmod +x $out/bin/pd
  '';
}
