{ inputs, ... }:
let
  defaultDesktopConfigHome = "/home/soywater/nixconfigs";
in
{
  flake.wrappers = {
    noctalia =
      { config, pkgs, wlib, ... }:
      let
        desktopConfigHome = config._module.args.desktopConfigHome or defaultDesktopConfigHome;
      in
      {
        imports = [ wlib.modules.default ];
        config = {
          package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
          env.NOCTALIA_CONFIG_HOME = wlib.mkOutOfStoreSymlink pkgs "${desktopConfigHome}/modules/features/desktop/config";
          env.NOCTALIA_STATE_HOME = "${desktopConfigHome}/.temp";
          env.FONTCONFIG_FILE = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.maple-mono-fontconfig;
        };
      };

    kitty =
      { config, pkgs, wlib, ... }:
      let
        desktopConfigHome = config._module.args.desktopConfigHome or defaultDesktopConfigHome;
      in
      {
        imports = [ wlib.modules.default ];
        config = {
          package = pkgs.kitty;
          env = {
            EDITOR = "hx";
            VISUAL = "hx";
            FONTCONFIG_FILE = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.maple-mono-fontconfig;
          };
          addFlag = [
            [ "--config" "${desktopConfigHome}/modules/features/desktop/config/kitty/kitty.conf" ]
            "--single-instance"
          ];
        };
      };

    vicinae =
      { config, pkgs, wlib, ... }:
      let
        desktopConfigHome = config._module.args.desktopConfigHome or defaultDesktopConfigHome;
      in
      {
        imports = [ wlib.modules.default ];
        config = {
          package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
          env.XDG_DATA_HOME = "${desktopConfigHome}/.temp";
          env.FONTCONFIG_FILE = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.maple-mono-fontconfig;
        };
      };

    desktop =
      { config, lib, pkgs, wlib, ... }:
      let
        desktopConfigHome = config._module.args.desktopConfigHome or defaultDesktopConfigHome;
        importDesktopModule = module: args@{ config, lib, pkgs, wlib, ... }:
          import module (args // { inherit inputs desktopConfigHome; });
      in
      {
        imports = [
          inputs.self.wrapperModules.niri
          (importDesktopModule ./noctalia-module)
          (importDesktopModule ./vicinae-module)
          (importDesktopModule ./kitty-module)
          (importDesktopModule ./force-kill-module)
          (importDesktopModule ./gpu-selector-module)
        ];
      };
  };

  flake.nixosModules.desktop =
    { config, packages, pkgs, ... }:
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
