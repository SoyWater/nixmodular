{ moduleWithSystem, inputs, ... }:
{
  flake.nixosModules.vicinae = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.vicinae ];
  });

  perSystem = { pkgs, ... }:
    let
      fontconfigFile = pkgs.writeText "maple-mono-fontconfig" ''<fontconfig><dir>${pkgs.maple-mono.NF-CN}/share/fonts</dir></fontconfig>'';
    in
    {
      packages.vicinae = inputs.wrappers.lib.wrapPackage ({ ... }: {
        inherit pkgs;
        package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
        env = {
          XDG_DATA_HOME = "/home/soywater/nixconfigs/.temp";
          FONTCONFIG_FILE = fontconfigFile;
        };
      });
    };
}
