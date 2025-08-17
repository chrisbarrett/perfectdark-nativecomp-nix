{ config, lib, pkgs, ... }:

let
  cfg = config.programs.perfectdark;
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
    home.packages = [ cfg.package ];

    home.activation.perfectdarkDataDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${cfg.dataDirectory}"
    '';

    home.sessionVariables = {
      PERFECTDARK_DATA_DIR = cfg.dataDirectory;
    };
  };
}
