let
  moduleName = "codex";
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
      codex
    ];
    # home.file.".codex/".source = (config.lib.my.setupSymlinkRel ./codex);
    # home.file.".codex/".recursive = true;

    imports = [
    ];
  };
}
