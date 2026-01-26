{ config, lib, pkgs, inputs, ... }:

let
  programName = "factorio";
  cfg = config.programs.${programName};

in
{
  options.programs.${programName} = {
    dataDirectory = lib.mkOption {
      type = lib.types.str;
      default = config.home.homeDirectory;
      description = "The specific path to the data directory for factorio to use.";
    };
  };

  config = {
    home.packages = [
      (pkgs.callPackage ./_default.nix {
        writeDir = cfg.dataDirectory;
        src = "${inputs.factorio-tarball}";
      })
    ];
    
  };
}
