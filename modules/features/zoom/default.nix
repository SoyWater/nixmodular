{ moduleWithSystem, ... }:
{
  perSystem = { pkgs, ... }: { packages.zoom = pkgs.zoom-us; };

  flake.nixosModules.zoom = moduleWithSystem ({ config, ... }: {
    environment.systemPackages = [ config.packages.zoom ];
  });
}
