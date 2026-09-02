{ moduleWithSystem, inputs, ... }:
{
  flake.nixosModules.noctalia = moduleWithSystem ({ self', pkgs, ... }:
  {
    imports = [ inputs.noctalia-greeter.nixosModules.default ];
    environment = {
      pathsToLink = [ "/share/wayland-sessions" ];
      systemPackages = [ self'.packages.noctalia pkgs.networkmanagerapplet ];
    };
    services.gnome.gnome-keyring.enable = true;
    security.polkit.extraConfig = ''
      polkit.addRule(function (action, subject) {
        if (action.id == "org.noctalia.greeter.apply-appearance" && subject.user == "soywater") {
          return polkit.Result.YES;
        }
      });
    '';
    services.displayManager.noctalia-greeter = {
      enable = true;
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
      };
      settings = {
        session.default = "niri";
        user.default = "soywater";
        cursor.size = 24;
      };
    };
  });

  perSystem = { pkgs, ... }:
    let
      fontconfigFile = pkgs.writeText "maple-mono-fontconfig" ''<fontconfig><dir>${pkgs.maple-mono.NF-CN}/share/fonts</dir></fontconfig>'';
    in
    {
      packages.noctalia = inputs.wrappers.lib.wrapPackage ({ wlib, ... }: {
        inherit pkgs;
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
        env = {
          NOCTALIA_CONFIG_HOME = wlib.mkOutOfStoreSymlink pkgs "/home/soywater/nixconfigs/modules/features/desktop/noctalia/config";
          NOCTALIA_STATE_HOME = "/home/soywater/nixconfigs/.temp";
          FONTCONFIG_FILE = fontconfigFile;
        };
      });
    };
}
