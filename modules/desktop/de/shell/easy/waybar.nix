{
  flake.modules.nixos.waybar = {
    
  };

  flake.modules.homeManager.waybar =
  { config, ... }:
  {
    programs.waybar.enable = true;
    xdg.configFile."waybar".source = (config.lib.my.setupSymlinkRel ./waybar);
    xdg.configFile."waybar".recursive = true;
  };
}
