
{
  flake.modules.homeManager.baseConfig =
  { config, ... }:
  {
      programs.starship.enable = true;
      programs.starship.enableFishIntegration = true;
      programs.starship.enableTransience = true;
      xdg.configFile."starship.toml".source = (config.lib.my.setupSymlinkRel ./starship.toml);
    };
}
