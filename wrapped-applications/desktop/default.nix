{ inputs, ... }:
{
  flake.wrappers = {
    noctalia =
      { pkgs, wlib, ... }:
      {
        imports = [ wlib.modules.default ];
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
        env.NOCTALIA_CONFIG_HOME = ./config;
      };

    niri =
      { lib, pkgs, wlib, ... }:
      {
        imports = [
          wlib.wrapperModules.niri
          (import ./niri-module { inherit lib pkgs wlib; })
        ];
      };

    desktop =
      { lib, pkgs, wlib, ... }:
      {
        imports = [
          wlib.wrapperModules.niri
          (import ./niri-module { inherit lib pkgs wlib; })
          ((import ./noctalia-module { inherit inputs; }) { inherit lib pkgs wlib; })
          (import ./force-kill-module { inherit pkgs; })
        ];
      };
  };
}
