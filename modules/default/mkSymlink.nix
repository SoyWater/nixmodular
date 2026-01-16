
{
  flake.modules.homeManager.baseConfig =
  { config, lib, inputs, ... }:
  {
    options = {
      dotFilesPath = lib.mkOption {
        type = lib.types.path;
        apply = toString;
        default = "${config.home.homeDirectory}/nixconfigs";
        description = "Absolute path to config folder";
      };
    };

    config = {
      lib.my.setupSymlinkRel = pathLiteral: let
        flakeRoot = toString inputs.self;

        targetPath = toString pathLiteral;

        relativePath = lib.removePrefix flakeRoot targetPath;
      in
        config.lib.file.mkOutOfStoreSymlink "${config.dotFilesPath}${relativePath}";
    };
  };
}

