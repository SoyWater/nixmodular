{ self, moduleWithSystem, ... }:
{
  # Terminal is a bundle, not the owner of individual application packages.
  flake.nixosModules.terminal = moduleWithSystem ({ ... }: {
    imports = with self.nixosModules; [
      terminalFish
      starship
      helix
    ];
  });
}
