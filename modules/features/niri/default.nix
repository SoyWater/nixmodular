{ moduleWithSystem, inputs, ... }:
{
  flake.nixosModules.niri = moduleWithSystem (
    { packages, ... }: {
      programs.niri.enable = true;
      programs.niri.package = packages.niri;
    }
  );

  perSystem = { lib, pkgs, ... }: {
    packages.niri = inputs.wrappers.wrappers.niri.wrap {
      inherit pkgs;
      imports = [
        ./niri-config
        (_: (import ./keybinds) { inherit lib pkgs; })
        ./gpu-selector-module
      ];
      runtimePkgs = [ pkgs.xwayland-satellite ];
      env = {
        XCURSOR_THEME = "Bibata-Modern-Ice";
        XCURSOR_SIZE = "24";
        XCURSOR_PATH = "${pkgs.bibata-cursors}/share/icons";
      };
      passthru.cargoBuildNoDefaultFeatures = pkgs.niri.cargoBuildNoDefaultFeatures;
      passthru.cargoBuildFeatures = pkgs.niri.cargoBuildFeatures;
    };
  };
}
