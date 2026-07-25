{ inputs, ... }:
let
  defaultDesktopConfigHome = "/home/soywater/nixconfigs";
in
{
  flake.wrappers = {
    noctalia =
      { config, pkgs, wlib, ... }:
      let
        desktopConfigHome = config._module.args.desktopConfigHome or defaultDesktopConfigHome;
      in
      {
        imports = [ wlib.modules.default ];
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
        env.NOCTALIA_CONFIG_HOME = wlib.mkOutOfStoreSymlink pkgs "${desktopConfigHome}/wrapped-applications/desktop/config";
        env.NOCTALIA_STATE_HOME = "${desktopConfigHome}/.temp";
      };

    kitty =
      { config, pkgs, wlib, ... }:
      let
        desktopConfigHome = config._module.args.desktopConfigHome or defaultDesktopConfigHome;
      in
      {
        imports = [ wlib.modules.default ];
        package = pkgs.kitty;
        addFlag = [
          [ "--config" "${desktopConfigHome}/wrapped-applications/desktop/config/kitty/kitty.conf" ]
          "--single-instance"
        ];
      };

    vicinae =
      { config, pkgs, wlib, ... }:
      let

        desktopConfigHome = config._module.args.desktopConfigHome or defaultDesktopConfigHome;
      in
      {
        imports = [ wlib.modules.default ];
        package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
        env.XDG_DATA_HOME = "${desktopConfigHome}/.temp";
      };

    niri =
      { lib, pkgs, wlib, ... }:
      {
        imports = [
          wlib.wrapperModules.niri
          (import ./niri-module {
            inherit lib pkgs wlib;
            desktopConfigHome = defaultDesktopConfigHome;
          })
        ];
      };

    desktop =
      { config, lib, pkgs, wlib, ... }:
      let
        desktopConfigHome = config._module.args.desktopConfigHome or defaultDesktopConfigHome;
        importDesktopModule = module: args@{ config, lib, pkgs, wlib, ... }:
          import module (args // { inherit inputs desktopConfigHome; });
      in
      {
        imports = [
          wlib.wrapperModules.niri
          (importDesktopModule ./niri-module)
          (importDesktopModule ./noctalia-module)
          (importDesktopModule ./vicinae-module)
          (importDesktopModule ./kitty-module)
          (importDesktopModule ./force-kill-module)
          (importDesktopModule ./gpu-selector-module)
        ];
      };
  };
}
