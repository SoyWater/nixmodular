{ moduleWithSystem, inputs, ... }:
{
  flake.nixosModules.kitty = moduleWithSystem (
    { packages, ... }: {
      environment = {
        systemPackages = [ packages.kitty ];
        sessionVariables.TERMINAL = "kitty";
        sessionVariables.LAUNCH_TERMINAL = "kitty --single-instance";
      };
    }
  );

  perSystem = { pkgs, ... }: {
    packages.kitty = inputs.wrappers.lib.wrapPackage (
      { ... }: {
        inherit pkgs;
        package = pkgs.kitty;
        env = {
          KITTY_CONFIG_DIRECTORY = "${./config}";
        };
        
      }
    );
  };
}
