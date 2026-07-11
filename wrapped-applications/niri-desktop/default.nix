{ ... }:
{
  flake.wrappers.niri-desktop =
    { lib, pkgs, wlib, ... }:
    let
      niriBaseConfig = lib.concatStringsSep "\n" (
        lib.filter
          (line: !(lib.hasPrefix "include " line))
          (lib.splitString "\n" (builtins.readFile ./config/config.kdl))
      );
      niriBaseConfigFile = pkgs.writeText "niri-base.kdl" niriBaseConfig;
      niriStaticIncludes = map toString [
        ./config/inputs.kdl
        ./config/binds.kdl
        ./config/dms/cursor.kdl
        ./config/dms/outputs.kdl
        ./config/dms/backdrop.kdl
        ./config/dms/alttab.kdl
        ./config/dms/wpblur.kdl
        ./config/dms/colors.kdl
        ./config/dms/layout.kdl
        ./config/dms/environment.kdl
        ./config/dms/binds.kdl
        ./config/dms/windowrules.kdl
      ];
      niriRuntimeIncludes = [
        "~/.local/state/niri/dms/cursor.kdl"
        "~/.local/state/niri/dms/outputs.kdl"
        "~/.local/state/niri/dms/backdrop.kdl"
        "~/.local/state/niri/dms/alttab.kdl"
        "~/.local/state/niri/dms/wpblur.kdl"
        "~/.local/state/niri/dms/colors.kdl"
        "~/.local/state/niri/dms/layout.kdl"
        "~/.local/state/niri/dms/environment.kdl"
        "~/.local/state/niri/dms/binds.kdl"
        "~/.local/state/niri/dms/windowrules.kdl"
      ];
    in
    {
      imports = [
        wlib.wrapperModules.niri
      ];
      package = pkgs.niri-unstable;
      disableConfigValidation = true;
      extraSettings =
        [ { include = toString niriBaseConfigFile; } ]
        ++ (map (path: { include = path; }) niriStaticIncludes)
        ++ (map (path: { include = [ { optional = true; } path ]; }) niriRuntimeIncludes);
      passthru.cargoBuildNoDefaultFeatures = pkgs.niri-unstable.cargoBuildNoDefaultFeatures;
      passthru.cargoBuildFeatures = pkgs.niri-unstable.cargoBuildFeatures;
    };
}
