let
  moduleName = "opencode";
in
{
  flake.modules.nixos.${moduleName}=
  { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [
    ];

    imports = [
    ];
  };

  flake.modules.homeManager.${moduleName} =
  { pkgs, config, ... }:
  {
    home.packages = with pkgs; [
      opencode
    ];
    xdg.configFile."opencode/opencode.json".source = (config.lib.my.setupSymlinkRel ./opencode/opencode.json);
    xdg.configFile."opencode/AGENTS.md".source = (config.lib.my.setupSymlinkRel ./opencode/AGENTS.md);
    xdg.configFile."opencode/agents".source = (config.lib.my.setupSymlinkRel ./opencode/agents);
    xdg.configFile."opencode/skills".source = (config.lib.my.setupSymlinkRel ./opencode/skills);

    imports = [
    ];
  };
}
