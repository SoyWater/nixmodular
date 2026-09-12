{ moduleWithSystem, ... }:
{
  flake.nixosModules.kitty = moduleWithSystem (
    { pkgs, ... }: {
      environment = {
        systemPackages = [ pkgs.kitty ];
        etc."xdg/kitty/kitty.conf".source = ./config/kitty.conf;
      };
    }
  );

  perSystem = { pkgs, ... }: {
    packages.kitty = pkgs.kitty;
  };
}
