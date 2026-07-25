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
      in
      {
        imports = [ wlib.modules.default ];
        package = pkgs.helix;
        env.FONTCONFIG_FILE = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.maple-mono-fontconfig;
        runtimePkgs = with pkgs; [
          nixd
          gopls
          typescript-language-server
          vscode-json-languageserver
          ty
          clang-tools
        ];
        addFlag = [
          [ "--config" "${terminalConfigHome}/wrapped-applications/terminal/config/helix/config.toml" ]
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
          (importTerminalModule ./zmx-module)
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
