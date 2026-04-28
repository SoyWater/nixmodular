{
  flake.modules.nixos.niri =
  { inputs, pkgs, ... }:
  {
    imports = [
      inputs.niri.nixosModules.niri
    ];

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
    programs.niri.enable = true;
    programs.niri.package = pkgs.niri-unstable;
    niri-flake.cache.enable = true;
    systemd.user.services.niri-flake-polkit.enable = false;
  };

  flake.modules.homeManager.niri =
  { config, lib, options, ... }:
  lib.mkMerge [
    (lib.optionalAttrs (lib.hasAttrByPath [ "programs" "niri" "config" ] options) {
      programs.niri.config = null;
    })
    {
      xdg.configFile."niri/config.kdl".source = config.lib.my.setupSymlinkRel ./config/config.kdl;
      xdg.configFile."niri/monitors.kdl".source = config.lib.my.setupSymlinkRel ./config/monitors.kdl;
      xdg.configFile."niri/inputs.kdl".source = config.lib.my.setupSymlinkRel ./config/inputs.kdl;
      xdg.configFile."niri/binds.kdl".source = config.lib.my.setupSymlinkRel ./config/binds.kdl;
      xdg.configFile."niri/noctalia.kdl".source = config.lib.my.setupSymlinkRel ./config/noctalia.kdl;
    }
  ];
}
