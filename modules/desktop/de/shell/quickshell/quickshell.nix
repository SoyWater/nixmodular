{
  flake.modules.nixos.quickshell =
  { ... }:
  {
    
  };

  flake.modules.homeManager.quickshell =
  { config, pkgs, ... }:
  {
    home.packages = [
      pkgs.kdePackages.qtdeclarative
    ];
    programs.quickshell.enable = true;
    programs.quickshell.systemd.enable = true;
    xdg.configFile."quickshell".source = (config.lib.my.setupSymlinkRel ./quickshell);
    xdg.configFile."quickshell".recursive = true;

    home.sessionVariables = {
      QML_IMPORT_PATH = "${pkgs.kdePackages.qtdeclarative}/lib/qmlls";
    };
  };
}
