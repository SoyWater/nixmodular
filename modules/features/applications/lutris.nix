{ moduleWithSystem, ... }:
{
  flake.nixosModules.lutris = moduleWithSystem ({ pkgs, ... }: {
    environment.systemPackages = [ pkgs.lutris ];
  });
}
