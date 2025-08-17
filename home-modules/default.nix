{ config, lib, pkgs, ... }:

let
  cfg = config.programs.perfectdark;

  # Create a wrapper that sets PERFECTDARK_DATA_DIR and launches the game
  wrappedPerfectDark = pkgs.symlinkJoin {
    name = "perfectdark-wrapped";
    paths = [ cfg.package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild =
      if pkgs.stdenv.isDarwin then ''
        wrapProgram $out/Applications/PerfectDark.app/Contents/MacOS/pd \
          --set PERFECTDARK_DATA_DIR "${cfg.dataDirectory}"
      '' else ''
        wrapProgram $out/bin/pd \
          --set PERFECTDARK_DATA_DIR "${cfg.dataDirectory}"
      '';
  };
in
{
  options.programs.perfectdark = {
    enable = lib.mkEnableOption "Perfect Dark port";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.perfectdark;
      defaultText = lib.literalExpression "pkgs.perfectdark";
      description = "Perfect Dark package to use";
    };

    dataDirectory = lib.mkOption {
      type = lib.types.str;
      default =
        if pkgs.stdenv.isDarwin
        then "${config.home.homeDirectory}/Library/Application Support/perfectdark/data"
        else "${config.home.homeDirectory}/.local/share/perfectdark/data";
      description = "Directory where Perfect Dark will look for ROM files and save data";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ wrappedPerfectDark ];

    home.activation.perfectdarkDataDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${cfg.dataDirectory}"
    '';
  };
}
