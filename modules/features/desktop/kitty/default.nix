{ moduleWithSystem, inputs, ... }:
{
  flake.nixosModules.kitty = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.kitty ];
  });

  perSystem = { pkgs, ... }:
    let fontconfigFile = pkgs.writeText "maple-mono-fontconfig" ''<fontconfig><dir>${pkgs.maple-mono.NF-CN}/share/fonts</dir></fontconfig>'';
    in {
    packages.kitty = inputs.wrappers.wrappers.kitty.wrap {
      inherit pkgs;
      env = {
        EDITOR = "hx";
        VISUAL = "hx";
        FONTCONFIG_FILE = fontconfigFile;
      };
      addFlag = [
        [ "--config" ./config/kitty.conf ]
        "--single-instance"
      ];
    };
  };
}
