{ inputs, ... }:
let
  defaultDesktopConfigHome = "/home/soywater/nixconfigs/wrapped-applications/desktop/config";
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
        env.NOCTALIA_CONFIG_HOME = wlib.mkOutOfStoreSymlink pkgs desktopConfigHome;
        env.NOCTALIA_STATE_HOME = "/home/soywater/.local/state/noctalia";
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
          [ "--config" "${desktopConfigHome}/kitty/kitty.conf" ]
          "--single-instance"
        ];
      };

    vicinae =
      { pkgs, wlib, ... }:
      {
        imports = [ wlib.modules.default ];
        package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };

    niri =
      { lib, pkgs, wlib, ... }:
      {
        imports = [
          wlib.wrapperModules.niri
          (import ./niri-module {
            inherit lib pkgs wlib defaultDesktopConfigHome;
          })
        ];
      };

    desktop =
      { lib, pkgs, wlib, ... }:
      let
        importDesktopModule = module: args@{ config, lib, pkgs, wlib, ... }:
          import module (args // { inherit inputs defaultDesktopConfigHome; });
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
