
{
  flake.modules.homeManager.baseConfig =
  { ... }:
  {
      programs.starship.enable = true;
      programs.starship.enableFishIntegration = true;
      programs.starship.enableTransience = true;
    };
}
