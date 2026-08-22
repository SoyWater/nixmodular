{ inputs, ... }:
{
  flake.nixosModules.terminal =
    { packages, pkgs, ... }:
    {
      environment.systemPackages = [
        packages.fish
        packages.starship
        packages.helix
        packages.direnv
        packages.fzf
        packages.yazi
        packages.zmx
        packages.zoxide
        packages.lazygit
      ];

      users.users.soywater.shell = packages.fish;

      programs = {
        fish = {
          enable = true;
          package = packages.fish;
          shellAliases = {
            ".." = "cd ..";
            "..." = "cd ../..";
            "...." = "cd ../../../";
            "....." = "cd ../../../../";
            configs = "cd ~/nixconfigs";

            cp = "cp -v";
            ddf = "df -h";
            mkdir = "mkdir -p";
            mv = "mv -v";
            rm = "rm -v";
            rr = "rm -rf";
          };
          interactiveShellInit = ''
            set -gx FONTCONFIG_FILE ${
              inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.maple-mono-fontconfig
            }
            abbr --add --position command ncg nix-collect-garbage
            fish_vi_key_bindings

            # The NixOS fzf module owns keybindings; source its Fish-only
            # command completion separately.
            source ${packages.fzf}/share/fzf/completion.fish

            # Kitty's runtime shell integration is available only to shells it
            # launches, so retain the guarded integration hook.
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

        starship = {
          enable = true;
          package = packages.starship;
          transientPrompt = {
            enable = true;
            left = "starship module character";
          };
        };

        # direnv ships its own Fish vendor hook, which Fish loads by default.
        direnv = {
          enable = true;
          enableFishIntegration = false;
        };
        fzf.keybindings = true;
        yazi.enable = true;
        zoxide.enable = true;
      };
    };
}
