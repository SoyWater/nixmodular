{ moduleWithSystem, inputs, ... }:
{
  flake.nixosModules.starship = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.starship ];
    programs.starship = {
      enable = true;
      package = self'.packages.starship;
      transientPrompt = { enable = true; left = "starship module character"; };
    };
  });

  perSystem = { pkgs, ... }: {
    packages.starship = inputs.wrappers.wrappers.starship.wrap {
      inherit pkgs;
      env.STARSHIP_CONFIG = pkgs.lib.mkForce "/home/soywater/nixconfigs/.temp/noctalia/themes/starship/matugen.toml";
    };
  };
}
