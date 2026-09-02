{ self, moduleWithSystem, ... }:
{
  # Desktop is intentionally just a bundle.  Each application owns both its
  # wrapper package and the NixOS configuration that installs it.
  flake.nixosModules.desktop = moduleWithSystem ({ ... }: {
    imports = with self.nixosModules; [
      niri
      noctalia
      kitty
      vicinae
    ];
  });
}
