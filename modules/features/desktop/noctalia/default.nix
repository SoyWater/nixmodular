{ moduleWithSystem, inputs, ... }:
{
  flake.nixosModules.noctalia = moduleWithSystem (
    { self', pkgs, ... }:
    {
      imports = [ inputs.noctalia-greeter.nixosModules.default ];
      environment = {
        pathsToLink = [ "/share/wayland-sessions" ];
        systemPackages = [
          self'.packages.noctalia
          pkgs.networkmanagerapplet
        ];
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
    }
  );

  perSystem = { pkgs, ... }: {
    packages.noctalia = inputs.wrappers.lib.wrapPackage (
      { ... }: {
        inherit pkgs;
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
        env = {
          # This path is copied to the Nix store, making the declarative base
          # configuration immutable at runtime. Noctalia's Settings UI keeps
          # its normal writable overlay in $XDG_STATE_HOME/noctalia.
          NOCTALIA_CONFIG_HOME = "${./config}";
        };
      }
    );
  };
}
