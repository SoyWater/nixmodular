{ moduleWithSystem, ... }:
{
  perSystem = { pkgs, ... }: { packages.gh-dash = pkgs.gh-dash; };

  flake.nixosModules.ghDash = moduleWithSystem ({ config, ... }: {
    environment.systemPackages = [ config.packages.gh-dash ];
  });
}
