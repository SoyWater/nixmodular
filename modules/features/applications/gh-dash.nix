{ moduleWithSystem, ... }:
{
  flake.nixosModules.ghDash = moduleWithSystem ({ pkgs, ... }: {
    environment.systemPackages = [ pkgs.gh-dash ];
  });
}
