{ inputs, ... }:
{
  # Exported automatically as `packages.<system>.niri` by nix-wrapper-modules.
  flake.wrappers.niri =
    { lib, pkgs, plugins ? [ ], wlib, ... }:
    {
      imports = [ wlib.wrapperModules.niri ];

      package = pkgs.niri;
      runtimePkgs = [ pkgs.xwayland-satellite ];
      env = {
        FONTCONFIG_FILE = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.maple-mono-fontconfig;
        XCURSOR_THEME = "Bibata-Modern-Ice";
        XCURSOR_SIZE = "24";
        XCURSOR_PATH = "${pkgs.bibata-cursors}/share/icons";
      };

      config.extraSettings =
        map (path: { include = path; }) [
          ./config/niri/config.kdl
          ./config/niri/monitors.kdl
          ./config/niri/inputs.kdl
          ./config/niri/binds.kdl
        ]
        ++ map (path: { include = [ { optional = true; } path ]; }) plugins;

      passthru.cargoBuildNoDefaultFeatures = pkgs.niri.cargoBuildNoDefaultFeatures;
      passthru.cargoBuildFeatures = pkgs.niri.cargoBuildFeatures;
      meta.platforms = lib.platforms.linux;
    };
}
