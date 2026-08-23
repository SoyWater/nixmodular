{ moduleWithSystem, ... }:
{
  perSystem = { inputs', ... }: { packages.neovim = inputs'.nvim.packages.default; };

  flake.nixosModules.neovim = moduleWithSystem ({ config, ... }: {
    environment.systemPackages = [ config.packages.neovim ];
  });
}
