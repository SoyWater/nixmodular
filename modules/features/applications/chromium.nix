{ ... }:
{
  flake.nixosModules.chromium = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.chromium ];
  };
}
