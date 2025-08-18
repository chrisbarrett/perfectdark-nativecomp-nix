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

      # See: https://github.com/fgsfdsfgs/perfect_dark/wiki/Command-line-parameters

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

      portable = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Use only executable directory, ignoring OS defaults.

          Setting this will prevent SDL from creating the root perfectdark
          configuration directory. You'll need to set `baseDirectory` and
          `saveDirectory` if you set this, since the Nix Store is a read-only
          filesystem.

          This is useful on macOS for keeping "~/Library/Application Support"
          nice and clean.
        '';
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
              portable = cfg.portable;
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
