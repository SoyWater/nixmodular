{ moduleWithSystem, ... }:
{
  perSystem = { inputs', ... }: {
    packages.factorio = inputs'.factorio-flake.packages.default;
  };

  flake.nixosModules.factorio = moduleWithSystem ({ packages, ... }: {
    environment.systemPackages = [ packages.factorio ];
  });
}
