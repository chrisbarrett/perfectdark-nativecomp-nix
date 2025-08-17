final: prev: {
  perfectdark = if prev.stdenv.isDarwin 
    then prev.callPackage ./packages/darwin.nix { }
    else prev.callPackage ./packages/linux.nix { };
    
  perfectdark-darwin = prev.callPackage ./packages/darwin.nix { };
  perfectdark-linux = prev.callPackage ./packages/linux.nix { };
}