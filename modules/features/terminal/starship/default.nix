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

  perSystem = { pkgs, ... }:
    let
      config = pkgs.writeText "starship.toml" (builtins.readFile ./config.toml);
      fallbackPalette = pkgs.writeText "starship-noctalia-fallback.toml" (builtins.readFile ./fallback-palette.toml);
    in
    {
      packages.starship = pkgs.writeShellApplication {
        name = "starship";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          palette="''${XDG_CACHE_HOME:-$HOME/.cache}/noctalia/starship-palette.toml"
          runtime_dir="''${XDG_RUNTIME_DIR:-/tmp}/starship"
          runtime_config="$runtime_dir/noctalia.toml"

          mkdir -p "$runtime_dir"
          candidate="$(mktemp "$runtime_dir/.noctalia.toml.XXXXXX")"
          trap 'rm -f "$candidate"' EXIT

          if [ -r "$palette" ]; then
            cat ${config} "$palette" > "$candidate"
          else
            cat ${config} ${fallbackPalette} > "$candidate"
          fi

          if [ ! -e "$runtime_config" ] || ! cmp -s "$candidate" "$runtime_config"; then
            mv "$candidate" "$runtime_config"
          fi

          export STARSHIP_CONFIG="$runtime_config"
          exec ${pkgs.starship}/bin/starship "$@"
        '';
      };
    };
}
