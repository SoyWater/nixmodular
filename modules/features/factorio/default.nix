{ moduleWithSystem, ... }:
{
  perSystem = { inputs', ... }: {
    packages.factorio = inputs'.factorio-flake.packages.default;
  };

  flake.nixosModules.factorio = moduleWithSystem ({ config, ... }: {
    environment.systemPackages = [ config.packages.factorio ];
  });
}
