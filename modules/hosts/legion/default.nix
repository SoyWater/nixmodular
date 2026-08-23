{ self, inputs, ... }:
{
  flake.nixosConfigurations.legion = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      core
      desktop
      terminal
      compression
      editors
      factorio
      ghDash
      lutris
      minecraft
      neovim
      zenBrowserWayland
      zoom
      services
      dualBoot
      virtualization
      soywater
      legion
      legionHardware
    ];
  };
}
