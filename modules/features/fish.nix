{ ... }:
{
  flake.nixosModules.terminalFish = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        fzf
        zmx
      ];
      users.defaultUserShell = pkgs.fish;
      programs.fish = {
        enable = true;
        package = pkgs.fish;
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
          ncg = "nix-collect-garbage";
        };
        extraCompletionPackages = [
          pkgs.fzf
        ];
        interactiveShellInit = "fish_vi_key_bindings";
        shellFunctions = {
          y.body = ''
            set -l cwd_file (mktemp -t yazi-cwd.XXXXXX)
            command yazi $argv --cwd-file="$cwd_file"
            if read -z cwd < "$cwd_file"; and test -n "$cwd"; and test "$cwd" != "$PWD"
              builtin cd -- "$cwd"
            end
            command rm -f -- "$cwd_file"
          '';
          yy.body = ''
            y $argv
          '';
          shx.body = ''
            set -l tmp (mktemp --suffix=.sh)
            or return 1

            "$EDITOR" "$tmp"
            set -l exit_status $status
            if test $exit_status -eq 0
              ${pkgs.bash}/bin/bash "$tmp"
              set exit_status $status
            end

            command rm -f -- "$tmp"
            return $exit_status
          '';
        };
      };
      programs.direnv.enable = true;
      programs.fzf.keybindings = true;
      programs.yazi.enable = true;
      programs.zoxide.enable = true;
      programs.lazygit.enable = true;
  };
}
