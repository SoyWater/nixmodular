{ ... }:
{
  flake.nixosModules.codex = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.codex ];
  };
}
