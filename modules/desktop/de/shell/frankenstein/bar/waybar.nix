{
  flake.modules.homeManager.frankenstein=
  { config, ... }:
  {
    programs.waybar.systemd.enable = true;
    programs.waybar.enable = true;
    xdg.configFile."waybar".source = (config.lib.my.setupSymlinkRel ./waybar);
    xdg.configFile."waybar".recursive = true;
  };
}
