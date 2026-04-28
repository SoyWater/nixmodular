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
    services.gnome.gnome-keyring.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        xdg-desktop-portal-termfilechooser
      ];
      config.niri = {
        default = [ "gtk" "gnome" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
    };
    programs.niri.enable = true;
    programs.niri.package = pkgs.niri-unstable;
    niri-flake.cache.enable = true;
    systemd.user.services.niri-flake-polkit.enable = false;
  };

  flake.modules.homeManager.niri =
  { config, lib, options, pkgs, ... }:
  lib.mkMerge [
    (lib.optionalAttrs (lib.hasAttrByPath [ "programs" "niri" "config" ] options) {
      programs.niri.config = null;
    })
    {
      home.sessionVariables.TERMCMD = "ghostty --title=termfilechooser --command";
      xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
        default_dir=$HOME
        open_mode=last
        save_mode=last
      '';
      xdg.configFile."niri/config.kdl".source = config.lib.my.setupSymlinkRel ./config/config.kdl;
      xdg.configFile."niri/monitors.kdl".source = config.lib.my.setupSymlinkRel ./config/monitors.kdl;
      xdg.configFile."niri/inputs.kdl".source = config.lib.my.setupSymlinkRel ./config/inputs.kdl;
      xdg.configFile."niri/binds.kdl".source = config.lib.my.setupSymlinkRel ./config/binds.kdl;
      xdg.configFile."niri/noctalia.kdl".source = config.lib.my.setupSymlinkRel ./config/noctalia.kdl;
    }
  ];
}
