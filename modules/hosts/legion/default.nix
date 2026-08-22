{ self, inputs, ... }:
{
  flake.nixosConfigurations.legion = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      core
      desktop
      terminal
      services
      dualBoot
      virtualization
      soywater
      legion
      legionHardware
    ];
  };
}
