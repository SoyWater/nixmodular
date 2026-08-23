{ moduleWithSystem, ... }:
{
  perSystem = { pkgs, ... }: {
    packages.editors = pkgs.buildEnv {
      name = "editors";
      paths = with pkgs; [ jetbrains.idea temurin-bin-21 zed-editor ];
    };
  };

  flake.nixosModules.editors = moduleWithSystem ({ config, ... }: {
    environment.systemPackages = [ config.packages.editors ];
  });
}
