{ inputs, ... }:
{
  flake.nixosModules.core = {
    imports = with inputs.self.nixosModules; [
      coreBoot
      coreLanguage
      coreNix
      corePrograms
      coreSecurity
      coreSops
    ];
  };
}
