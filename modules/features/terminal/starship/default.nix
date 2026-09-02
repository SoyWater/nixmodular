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
      # Noctalia's built-in template preserves this file's prompt layout and
      # replaces only its marked [palettes.noctalia] block.
      env.STARSHIP_CONFIG = pkgs.lib.mkForce "/home/soywater/.config/starship.toml";
    };
  };
}
