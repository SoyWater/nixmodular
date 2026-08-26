{ ... }:
{
  flake.nixosModules.gh = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.gh ];
  };
}
