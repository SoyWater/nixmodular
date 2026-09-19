{ self, inputs, ... }:
{
  flake.nixosConfigurations.legion = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      core
      fonts
      niri
      noctalia
      kitty
      vicinae
      terminalFish
      starship
      helix
      applications
      dictation
      sandboxing
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
