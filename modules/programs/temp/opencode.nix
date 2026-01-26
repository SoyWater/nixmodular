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
    xdg.configFile."opencode/opencode.json".source = (config.lib.my.setupSymlinkRel ./opencode.json);

    imports = [
    ];
  };
}
