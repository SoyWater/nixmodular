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
      dualBoot
      virtualization
      soywater
      legion
      legionHardware
      audio
      bluetooth
      firmware
      graphics
      hardwareTools
      network
      nix-ld
      power
      removableStorage
      media
      runtime
    ];
  };
}
