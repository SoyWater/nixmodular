{ lib, config, pkgs, ... }:

{
  options = {
    starship.enable = lib.mkEnableOption {
      name = "enable starship";
      default = true;
    };
  };

  config = lib.mkIf config.starship.enable {
    programs.starship.enable = true;
    programs.starship.enableFishIntegration = config.fish.enable;
    programs.starship.enableTransience = config.fish.enable;
    xdg.configFile."starship.toml".source = ./starship.toml;
    programs.starship.settings = {
      # format = lib.concatStrings [
        # "[](fg:#d3d7cf)"
        # "$os"
        # "$username"
        # "[](fg:#d3d7cf bg:#3465a4)"
        # "$directory"
        # "[](fg:#3465a4 bg:#4e9a06)"
        # "$git_branch"
        # "$git_status"
        # "[](fg:#4e9a06)"
        # "$fill"
        # "$c"
        # "$direnv"
        # "$elixir"
        # "$elm"
        # "$golang"
        # "$gradle"
        # "$haskell"
        # "$java"
        # "$julia"
        # "$nodejs"
        # "$nim"
        # "$python"
        # "$rust"
        # "$scala"
        # "$docker_context"
        # "[](fg:#d3d7cf)"
        # "$time"
        # "$cmd_duratio"
        # "󱞪    "
      # ];
    };
  };
}
