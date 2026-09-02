{ moduleWithSystem, ... }:
{
  flake.nixosModules.terminalFish = moduleWithSystem ({ self', pkgs, ... }: {
    environment.systemPackages = with pkgs; [ fish direnv fzf lazygit yazi zmx zoxide ];
    users.defaultUserShell = pkgs.fish;
    programs.fish = {
      enable = true;
      package = pkgs.fish;
      shellAliases = {
        ".." = "cd .."; "..." = "cd ../.."; "...." = "cd ../../../"; "....." = "cd ../../../../";
        configs = "cd ~/nixconfigs"; cp = "cp -v"; ddf = "df -h"; mkdir = "mkdir -p"; mv = "mv -v"; rm = "rm -v"; rr = "rm -rf";
        ncg = "nix-collect-garbage";
      };
      shellAbbrs.nsf = "sudo nixos-rebuild switch --flake ~/nixconfigs#";
      interactiveShellInit = ''
        set -gx FONTCONFIG_FILE ${self'.packages.maple-mono-fontconfig}
        fish_vi_key_bindings
        source ${pkgs.fzf}/share/fzf/completion.fish
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
    programs.direnv = { enable = true; enableFishIntegration = false; };
    programs.fzf.keybindings = true;
    programs.yazi.enable = true;
    programs.zoxide.enable = true;
  });
}
