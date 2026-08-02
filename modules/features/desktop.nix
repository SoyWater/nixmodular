{ ... }:
{
  flake.modules.nixos.desktop =
    { config, inputs, packages, pkgs, ... }:
    let
      desktopConfigHome = "${config.users.users.soywater.home}/nixconfigs";
      desktopPackage = packages.desktop.wrap {
        _module.args.desktopConfigHome = desktopConfigHome;
      };
    in
    {
      imports = [ inputs.noctalia-greeter.nixosModules.default ];

      environment = {
        pathsToLink = [ "/share/wayland-sessions" ];
        # nm-applet is NetworkManager's desktop secret agent.  It supplies the
        # OpenConnect authentication flow (including the SSO browser handoff).
        systemPackages = [ desktopPackage pkgs.networkmanagerapplet ];
      };

      services.gnome.gnome-keyring.enable = true;

      # Allow the logged-in desktop user to update only the greeter appearance
      # data, so Noctalia's wallpaper/theme auto-sync does not prompt.
      security.polkit.extraConfig = ''
        polkit.addRule(function (action, subject) {
          if (
            action.id == "org.noctalia.greeter.apply-appearance" &&
            subject.user == "soywater"
          ) {
            return polkit.Result.YES;
          }
        });
      '';

      hardware.logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };

      # Solaar needs this to emulate key events for device rules.  Keep the
      # capability limited to the logged-in desktop user.
      hardware.uinput.enable = true;
      users.groups.uinput.members = [ "soywater" ];

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
