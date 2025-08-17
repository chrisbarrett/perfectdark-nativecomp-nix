{ config, lib, pkgs, ... }:

let
  cfg = config.programs.perfectdark;

  wrappedPerfectDark = pkgs.symlinkJoin {
    name = "perfectdark-wrapped";
    paths = [ cfg.package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild =
      if pkgs.stdenv.isDarwin then ''
        wrapProgram $out/Applications/PerfectDark.app/Contents/MacOS/pd \
          --add-flags --basedir='${cfg.baseDirectory}'
      '' else ''
        wrapProgram $out/bin/pd \
          --add-flags --basedir='${cfg.baseDirectory}'
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

    baseDirectory = lib.mkOption {
      type = lib.types.str;
      default =
        if pkgs.stdenv.isDarwin
        then "${config.home.homeDirectory}/Library/Application Support/perfectdark"
        else "${config.home.homeDirectory}/.local/share/perfectdark";
      description = "Directory for Perfect Dark's runtime configuration and data dirs";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ wrappedPerfectDark ];

    home.activation.perfectdarkDataDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${cfg.baseDirectory}/data"
    '';
  };
}
