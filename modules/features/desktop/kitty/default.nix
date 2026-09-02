{ moduleWithSystem, inputs, ... }:
{
  flake.nixosModules.kitty = moduleWithSystem (
    { self', ... }: {
      environment.systemPackages = [ self'.packages.kitty ];
    }
  );

  perSystem = { pkgs, ... }: {
    packages.kitty = inputs.wrappers.wrappers.kitty.wrap {
      inherit pkgs;
      env = {
        EDITOR = "hx";
        VISUAL = "hx";
      };
      addFlag = [
        [
          "--config"
          ./config/kitty.conf
        ]
        "--single-instance"
      ];
    };
  };
}
