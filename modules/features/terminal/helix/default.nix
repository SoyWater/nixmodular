{ moduleWithSystem, inputs, ... }:
{
  flake.nixosModules.helix = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.helix ];
  });

  perSystem = { pkgs, ... }:
    let
      fontconfigFile = pkgs.writeText "maple-mono-fontconfig" ''<fontconfig><dir>${pkgs.maple-mono.NF-CN}/share/fonts</dir></fontconfig>'';
      forest = pkgs.fetchFromGitHub {
        owner = "Ra77a3l3-jar";
        repo = "forest.hx";
        rev = "40e5aadf64b652534978a644dfc8536d95f7cabd";
        hash = "sha256-oclnuR77thCeZh/A/qP3xfUuO6hkuAI4eVgEgGUeEjA=";
      };
      notify = pkgs.fetchFromGitHub {
        owner = "chuwy";
        repo = "notify.hx";
        rev = "0a328073e6d3e5041346374ae747c275ab8ce746";
        hash = "sha256-shKUVnJw2j0yYO+mTHsKie+d1VrJGWDTRul+PTpqlhs=";
      };
      glyph = pkgs.fetchFromGitHub {
        owner = "Ra77a3l3-jar";
        repo = "glyph.hx";
        rev = "1e63ccbc8f17511543412c955879ba672f3f8ec1";
        hash = "sha256-TpYnGqROkKfoB9G+JTjADWvMtpRJbv4NVaTqiUfW1Eg=";
      };
      steelixConfigHome = pkgs.runCommand "steelix-config-home" { } ''
        mkdir -p "$out/helix/themes"
        cp ${./config/config.toml} "$out/helix/config.toml"
        cp ${./config/init.scm} "$out/helix/init.scm"
        ln -s /home/soywater/nixconfigs/.temp/noctalia/themes/helix/matugen.toml "$out/helix/themes/matugen.toml"
      '';
      steelix = pkgs.writeShellApplication {
        name = "hx";
        runtimeInputs = with pkgs; [ pkgs.steelix nixd gopls typescript-language-server vscode-json-languageserver ty clang-tools ];
        text = ''
          steel_data_home="''${XDG_DATA_HOME:-$HOME/.local/share}/steel"
          mkdir -p "$steel_data_home/cogs"
          ln -sfn ${forest} "$steel_data_home/cogs/forest"
          ln -sfn ${notify} "$steel_data_home/cogs/notify"
          ln -sfn ${glyph} "$steel_data_home/cogs/glyph"
          export XDG_CONFIG_HOME=${steelixConfigHome}
          export FONTCONFIG_FILE=${fontconfigFile}
          exec ${pkgs.steelix}/bin/hx --config ${steelixConfigHome}/helix/config.toml "$@"
        '';
      };
    in
    {
      packages.helix = inputs.wrappers.lib.wrapPackage ({ ... }: {
        inherit pkgs;
        package = steelix;
      });
    };
}
