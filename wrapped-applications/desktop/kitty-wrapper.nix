{ inputs, ... }:
{
  flake.wrappers.kitty =
    { config, pkgs, wlib, ... }:
    let
      desktopConfigHome = config._module.args.desktopConfigHome or "/home/soywater/nixconfigs";
    in
    {
      imports = [ wlib.modules.default ];
      package = pkgs.kitty;

      # Keep the explicitly selected font available when Kitty runs outside
      # the Niri session too.
      env.FONTCONFIG_FILE = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.maple-mono-fontconfig;
      addFlag = [
        [ "--config" "${desktopConfigHome}/wrapped-applications/desktop/config/kitty/kitty.conf" ]
        "--single-instance"
      ];
    };
}
