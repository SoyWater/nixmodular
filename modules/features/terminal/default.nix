{ inputs, moduleWithSystem, ... }:
let
  defaultTerminalConfigHome = "/home/soywater/nixconfigs";
in
{
  flake.wrappers = {
    starship = { config, pkgs, wlib, ... }:
      let terminalConfigHome = config._module.args.terminalConfigHome or defaultTerminalConfigHome;
      in {
        imports = [ wlib.modules.default ];
        package = pkgs.starship;
        env.STARSHIP_CONFIG = "${terminalConfigHome}/.temp/noctalia/themes/starship/matugen.toml";
      };

    helix = { config, pkgs, wlib, ... }:
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
          rev = "1e63cc8f17511543412c955879ba672f3f8ec1";
          hash = "sha256-TpYnGqROkKfoB9G+JTjADWvMtpRJbv4NVaTqiUfW1Eg=";
        };
        steelixConfigHome = pkgs.runCommand "steelix-config-home" { } ''
          mkdir -p "$out/helix/themes" "$out/steel/cogs"
          cp ${./wrapper/config/helix/config.toml} "$out/helix/config.toml"
          cp ${./wrapper/config/helix/init.scm} "$out/helix/init.scm"
          ln -s ${forest} "$out/steel/cogs/forest"
          ln -s ${notify} "$out/steel/cogs/notify"
          ln -s ${glyph} "$out/steel/cogs/glyph"
          ln -s ${terminalConfigHome}/.temp/noctalia/themes/helix/matugen.toml "$out/helix/themes/matugen.toml"
        '';
      in {
        imports = [ wlib.modules.default ];
        package = pkgs.steelix;
        env.FONTCONFIG_FILE = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.maple-mono-fontconfig;
        env.XDG_CONFIG_HOME = steelixConfigHome;
        env.XDG_DATA_HOME = steelixConfigHome;
        runtimePkgs = with pkgs; [ nixd gopls typescript-language-server vscode-json-languageserver ty clang-tools ];
        addFlag = [ [ "--config" "${steelixConfigHome}/helix/config.toml" ] ];
      };
  };

  perSystem = { pkgs, ... }: {
    packages = with pkgs; { inherit direnv fish fzf lazygit yazi zmx zoxide; };
  };

  flake.nixosModules.terminal = moduleWithSystem ({ config, pkgs, ... }: {
    environment.systemPackages = with config.packages; [ fish starship helix direnv fzf yazi zmx zoxide lazygit ];
    users.users.soywater.shell = config.packages.fish;
    programs.fish = {
      enable = true;
      package = config.packages.fish;
      shellAliases = {
        ".." = "cd .."; "..." = "cd ../.."; "...." = "cd ../../../"; "....." = "cd ../../../../";
        configs = "cd ~/nixconfigs"; cp = "cp -v"; ddf = "df -h"; mkdir = "mkdir -p"; mv = "mv -v"; rm = "rm -v"; rr = "rm -rf";
      };
      interactiveShellInit = ''
        set -gx FONTCONFIG_FILE ${config.packages.maple-mono-fontconfig}
        abbr --add --position command ncg nix-collect-garbage
        fish_vi_key_bindings
        source ${config.packages.fzf}/share/fzf/completion.fish
        if set -q KITTY_INSTALLATION_DIR
          set kitty_fish "$KITTY_INSTALLATION_DIR/shell-integration/fish"
          if test -f "$kitty_fish/vendor_conf.d/kitty-shell-integration.fish"
            source "$kitty_fish/vendor_conf.d/kitty-shell-integration.fish"
          end
          if test -d "$kitty_fish/vendor_completions.d"
            set -a fish_complete_path "$kitty_fish/vendor_completions.d"
          end
          set -e kitty_fish
        end
        function nsf -a host
          sudo nixos-rebuild switch --flake ~/nixconfigs#$host --verbose
        end
        function config -a name
          nix flake init -t mytemplates; and mv config.nix $name.nix
        end
        function y
          set -l cwd_file (mktemp -t yazi-cwd.XXXXXX)
          command yazi $argv --cwd-file="$cwd_file"
          if read -z cwd < "$cwd_file"; and test -n "$cwd"; and test "$cwd" != "$PWD"
            builtin cd -- "$cwd"
          end
          rm -f -- "$cwd_file"
        end
        function yy
          y $argv
        end
      '';
    };
    programs.starship = { enable = true; package = config.packages.starship; transientPrompt = { enable = true; left = "starship module character"; }; };
    programs.direnv = { enable = true; enableFishIntegration = false; };
    programs.fzf.keybindings = true;
    programs.yazi.enable = true;
    programs.zoxide.enable = true;
  });
}
