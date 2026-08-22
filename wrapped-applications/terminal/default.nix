{ inputs, ... }:
let
  defaultTerminalConfigHome = "/home/soywater/nixconfigs";
in
{
  flake.wrappers = {
    # Keep exports in one place.  The terminal composition below imports the
    # corresponding per-tool modules, so adding or removing a tool is a
    # one-line change to each list.
    starship =
      { config, pkgs, wlib, ... }:
      let
        terminalConfigHome = config._module.args.terminalConfigHome or defaultTerminalConfigHome;
      in
      {
        imports = [ wlib.modules.default ];
        package = pkgs.starship;
        env.STARSHIP_CONFIG = "${terminalConfigHome}/.temp/noctalia/themes/starship/matugen.toml";
      };

    helix =
      { config, pkgs, wlib, ... }:
      let
        terminalConfigHome = config._module.args.terminalConfigHome or defaultTerminalConfigHome;
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
          mkdir -p "$out/helix/cogs" "$out/helix/themes"
          cp ${./config/helix/config.toml} "$out/helix/config.toml"
          cp ${./config/helix/init.scm} "$out/helix/init.scm"
          ln -s ${forest} "$out/helix/cogs/forest"
          ln -s ${notify} "$out/helix/cogs/notify"
          ln -s ${glyph} "$out/helix/cogs/glyph"
          ln -s ${terminalConfigHome}/.temp/noctalia/themes/helix/matugen.toml "$out/helix/themes/matugen.toml"
        '';
      in
      {
        imports = [ wlib.modules.default ];
        package = pkgs.steelix;
        env.FONTCONFIG_FILE = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.maple-mono-fontconfig;
        # Steelix discovers init.scm and the Nix-vendored cogs beneath this
        # directory.  Scope it to hx rather than leaking XDG_CONFIG_HOME into
        # Kitty or Fish.
        env.XDG_CONFIG_HOME = steelixConfigHome;
        runtimePkgs = with pkgs; [
          nixd
          gopls
          typescript-language-server
          vscode-json-languageserver
          ty
          clang-tools
        ];
        addFlag = [
          [ "--config" "${steelixConfigHome}/helix/config.toml" ]
        ];
      };

    terminal =
      { config, lib, pkgs, wlib, ... }:
      let
        terminalConfigHome = config._module.args.terminalConfigHome or defaultTerminalConfigHome;
        importTerminalModule = module: args@{ config, lib, pkgs, wlib, ... }:
          import module (args // { inherit inputs terminalConfigHome; });
      in
      {
        imports = [
          (importTerminalModule ./fish-module)
          (importTerminalModule ./kitty-module)
          (importTerminalModule ./direnv-module)
          (importTerminalModule ./fzf-module)
          (importTerminalModule ./helix-module)
          (importTerminalModule ./zoxide-module)
          (importTerminalModule ./starship-module)
          (importTerminalModule ./yazi-module)
          (importTerminalModule ./lazygit-module)
          (importTerminalModule ./zmx-module)
          (importTerminalModule ./ide-module)
        ];
      };
  };

  perSystem = { config, pkgs, ... }: {
    # `fish` is the canonical terminal shell, not a second divergent wrapper.
    packages = {
      fish = config.packages.terminal;
      inherit (pkgs) direnv fzf yazi zmx zoxide;
    };
  };
}
