{ moduleWithSystem, inputs, ... }:
{
  flake.nixosModules.vicinae = moduleWithSystem (
    { self', ... }: {
      environment.systemPackages = [ self'.packages.vicinae ];
    }
  );

  perSystem = { pkgs, ... }: {
    packages.vicinae = inputs.wrappers.lib.wrapPackage (
      { ... }: {
        inherit pkgs;
        package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
        env = {
          XDG_DATA_HOME = "/home/soywater/nixconfigs/.temp";
        };
      }
    );
  };
}
