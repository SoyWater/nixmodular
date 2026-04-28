{
  flake.modules.nixos.dms =
  { inputs, lib, ... }:
  {
    imports = [
      inputs.dms.nixosModules.dank-material-shell
      inputs.dms.nixosModules.greeter
    ];

    programs.dank-material-shell = {
      enable = true;
      greeter = {
        enable = true;
        compositor.name = "niri";
        configHome = "/home/soywater";
      };
    };
    services.upower.enable = lib.mkDefault true;
  };

  flake.modules.homeManager.dms =
  { config, inputs, ... }:
  {
    imports = [
      inputs.dms.homeModules.dank-material-shell
    ];

    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;
    };

    xdg.configFile."niri/dms".source = config.lib.my.setupSymlinkRel ./config;
    xdg.configFile."niri/dms".recursive = true;
  };
}
