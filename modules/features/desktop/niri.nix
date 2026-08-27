{ inputs, ... }:
{
  # Exported automatically as `packages.<system>.niri` by nix-wrapper-modules.
  flake.wrappers.niri =
    { config, lib, pkgs, wlib, ... }:
    let
      plugins = config._module.args.plugins or [ ];
    in
    {
      imports = [ wlib.wrapperModules.niri ];

      config = {
        package = pkgs.niri;
        runtimePkgs = [ pkgs.xwayland-satellite ];
        env = {
          EDITOR = "hx";
          VISUAL = "hx";
          FONTCONFIG_FILE = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.maple-mono-fontconfig;
          XCURSOR_THEME = "Bibata-Modern-Ice";
          XCURSOR_SIZE = "24";
          XCURSOR_PATH = "${pkgs.bibata-cursors}/share/icons";
        };

        extraSettings =
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
    };
}
