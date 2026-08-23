{ moduleWithSystem, ... }:
{
  perSystem = { pkgs, ... }: { packages.lutris = pkgs.lutris; };

  flake.nixosModules.lutris = moduleWithSystem ({ config, ... }: {
    environment.systemPackages = [ config.packages.lutris ];
  });
}
