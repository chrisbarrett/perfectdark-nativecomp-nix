{ config, lib, pkgs, ... }:

let
  cfg = config.programs.perfectdark;
in
{
  options.programs.perfectdark =
    let
      inherit (lib) types;
    in
    {
      enable = lib.mkEnableOption "Perfect Dark port";

      package = lib.mkOption {
        type = types.package;
        default = pkgs.perfectdark;
        defaultText = lib.literalExpression "pkgs.perfectdark";
        description = "Perfect Dark package to use";
      };

      baseDirectory = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Override path to the base data directory, i.e. the one where your ROM file is.";
      };

      saveDirectory = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Override save directory path";
      };

      modDirectory = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Specify mod directory name/path";
      };

      romFile = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Override ROM file name/path";
      };

      eepromFile = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Override EEPROM save file name/path";
      };

      profile = lib.mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Automatically select player file";
      };

      skipIntro = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Skip intro sequence";
      };
    };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.symlinkJoin {
        name = "perfectdark-wrapped";
        paths = [ cfg.package ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild =
          let
            programPath = if pkgs.stdenv.isDarwin then "$out/Applications/PerfectDark.app/Contents/MacOS/pd" else "$out/bin/pd";

            args = lib.cli.toGNUCommandLineShell { } {
              basedir = cfg.baseDirectory;
              savedir = cfg.saveDirectory;
              moddir = cfg.modDirectory;
              rom-file = cfg.romFile;
              eeprom-file = cfg.eepromFile;
              profile = cfg.profile;
              skip-intro = cfg.skipIntro;
            };
          in
          ''
            wrapProgram ${programPath} --add-flags "${args}"
          '';
      })
    ];
  };
}
