{ self, inputs, ... }:
{
  flake.nixosConfigurations.legion = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      inputs.nix-index-database.nixosModules.nix-index
      core
      desktop
      terminal
      applications
      compression
      minecraft
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
    ];
  };
}
