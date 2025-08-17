{ pkgs, stdenv }: pkgs.callPackage ./builder.nix {
  cmakeFlags = [
    "-DCMAKE_OSX_ARCHITECTURES=${if stdenv.isAarch64 then "arm64" else "x86_64"}"
  ];

  installPhase = ''
    mkdir -p $out/Applications/PerfectDark.app/Contents/{MacOS,Resources,Frameworks}

    # Copy the main executable
    cp pd.* $out/Applications/PerfectDark.app/Contents/MacOS/pd
    chmod +x $out/Applications/PerfectDark.app/Contents/MacOS/pd

    # Copy Info.plist and icon
    cp ${./macos/Info.plist} $out/Applications/PerfectDark.app/Contents/Info.plist
    cp ${./macos/icon.icns} $out/Applications/PerfectDark.app/Contents/Resources/icon.icns

    # Copy dynamic libraries to the app bundle
    cp -r ${pkgs.sdl2-compat}/lib/libSDL2*.dylib $out/Applications/PerfectDark.app/Contents/Frameworks/ || true
    cp -r ${pkgs.zlib}/lib/libz*.dylib $out/Applications/PerfectDark.app/Contents/Frameworks/ || true

    # Fix library paths to use bundled versions
    install_name_tool -change ${pkgs.sdl2-compat}/lib/libSDL2-2.0.0.dylib @executable_path/../Frameworks/libSDL2-2.0.0.dylib $out/Applications/PerfectDark.app/Contents/MacOS/pd || true
    install_name_tool -change ${pkgs.zlib}/lib/libz.dylib @executable_path/../Frameworks/libz.dylib $out/Applications/PerfectDark.app/Contents/MacOS/pd || true
  '';
}
