{ inputs, ... }:
{
  flake.nixosModules.codebuddy =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.codebuddy.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
