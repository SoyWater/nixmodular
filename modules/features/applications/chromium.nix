{ ... }:
{
  flake.nixosModules.chromium = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.chromium pkgs.obsidian ];
  };
}
