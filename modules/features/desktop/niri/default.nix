{ moduleWithSystem, inputs, ... }:
{
  flake.nixosModules.niri = moduleWithSystem (
    { self', pkgs, ... }: {
      environment.systemPackages = [ self'.packages.niri ];
    }
  );

  perSystem = { pkgs, ... }: {
    packages.niri = inputs.wrappers.wrappers.niri.wrap {
      inherit pkgs;
      imports = [
        ./force-kill-module
        ./gpu-selector-module
      ];
      runtimePkgs = [ pkgs.xwayland-satellite ];
      env = {
        EDITOR = "hx";
        VISUAL = "hx";
        XCURSOR_THEME = "Bibata-Modern-Ice";
        XCURSOR_SIZE = "24";
        XCURSOR_PATH = "${pkgs.bibata-cursors}/share/icons";
      };
      # The app configurations are immutable store paths; user-generated
      # Noctalia theme files remain optional at their runtime location.
      extraSettings = [
        { include = ./config/config.kdl; }
        { include = ./config/monitors.kdl; }
        { include = ./config/inputs.kdl; }
        { include = ./config/binds.kdl; }
        {
          include = [
            { optional = true; }
            ./../noctalia/config/noctalia.kdl
          ];
        }
        {
          include = [
            { optional = true; }
            "/home/soywater/nixconfigs/.temp/noctalia/themes/niri/noctalia.kdl"
          ];
        }
        {
          "spawn-at-startup" = [
            "vicinae"
            "server"
            "--config"
            "/home/soywater/nixconfigs/modules/features/desktop/vicinae/config/settings.json"
          ];
        }
      ];
      passthru.cargoBuildNoDefaultFeatures = pkgs.niri.cargoBuildNoDefaultFeatures;
      passthru.cargoBuildFeatures = pkgs.niri.cargoBuildFeatures;
    };
  };
}
