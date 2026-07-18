{
  flake.modules.nixos.desktop =
    { inputs, lib, packages, pkgs, ... }:
    {
      imports = [ inputs.noctalia-greeter.nixosModules.default ];

      environment = {
        pathsToLink = [ "/share/wayland-sessions" ];
        systemPackages = [
          packages.desktop
          pkgs.bibata-cursors
        ];
        sessionVariables = {
          XCURSOR_THEME = "Bibata-Modern-Ice";
          XCURSOR_SIZE = "24";
          XCURSOR_PATH = lib.mkAfter [ "${pkgs.bibata-cursors}/share/icons" ];
        };
      };

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

      programs.noctalia-greeter = {
        enable = true;
        settings = {
          session.default = "niri";
          user.default = "soywater";
          cursor = {
            theme = "Bibata-Modern-Ice";
            size = 24;
            path = "${pkgs.bibata-cursors}/share/icons";
          };
        };
      };
    };
}
