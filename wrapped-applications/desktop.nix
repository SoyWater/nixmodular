{ ... }:
{
  perSystem = { pkgs, ... }: {
    wrappers.control_type = "build";
    wrappers.packages = {
      ghostty-dms = pkgs.stdenv.isLinux;
      niri-desktop = pkgs.stdenv.isLinux;
      starship-dms = pkgs.stdenv.isLinux;
    };
  };

  flake.wrappers.niri-desktop =
    { lib, pkgs, wlib, ... }:
    let
      configRoot = "/home/soywater/nixconfigs";
      outOfStore = relativePath:
        wlib.mkOutOfStoreSymlink pkgs "${configRoot}/${relativePath}";
      niriBaseConfig = lib.concatStringsSep "\n" (
        lib.filter
          (line: !(lib.hasPrefix "include " line))
          (lib.splitString "\n" (builtins.readFile ../modules/desktop/de/wm/niri/config/config.kdl))
      );
      niriBaseConfigFile = pkgs.writeText "niri-base.kdl" niriBaseConfig;
      niriStaticIncludes = map (relativePath: toString (outOfStore relativePath)) [
        "modules/desktop/de/wm/niri/config/inputs.kdl"
        "modules/desktop/de/wm/niri/config/binds.kdl"
        "modules/desktop/de/shell/dms/config/cursor.kdl"
        "modules/desktop/de/shell/dms/config/outputs.kdl"
        "modules/desktop/de/shell/dms/config/backdrop.kdl"
        "modules/desktop/de/shell/dms/config/alttab.kdl"
        "modules/desktop/de/shell/dms/config/wpblur.kdl"
        "modules/desktop/de/shell/dms/config/colors.kdl"
        "modules/desktop/de/shell/dms/config/layout.kdl"
        "modules/desktop/de/shell/dms/config/environment.kdl"
        "modules/desktop/de/shell/dms/config/binds.kdl"
        "modules/desktop/de/shell/dms/config/outputs.kdl"
        "modules/desktop/de/shell/dms/config/windowrules.kdl"
        "modules/desktop/de/shell/dms/config/cursor.kdl"
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

  flake.wrappers.ghostty-dms = { pkgs, wlib, ... }: {
    imports = [
      wlib.modules.default
    ];
    package = pkgs.ghostty;
  };

  flake.wrappers.starship-dms = { pkgs, wlib, ... }: {
    imports = [
      wlib.modules.default
    ];
    package = pkgs.starship;
  };
}
