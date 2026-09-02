{ self, inputs, ... }:
{
  flake.nixosConfigurations.legion = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      codebuddy
      inputs.nix-index-database.nixosModules.nix-index
      core
      desktop
      terminal
      codex
      chromium
      gh
      compression
      editors
      factorio
      ghDash
      lutris
      minecraft
      zenBrowserWayland
      services
      dualBoot
      virtualization
      soywater
      legion
      legionHardware
      audio
      network
      nix-ld
    ];
  };
}
