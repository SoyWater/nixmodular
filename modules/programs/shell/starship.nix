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
    xdg.configFile."starship.toml".source = (config.lib.my.setupSymlinkRel ./starship.toml);
  };
}
