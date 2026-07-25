{
  flake.wrappers.kitty =
    { config, pkgs, wlib, ... }:
    let
      desktopConfigHome = config._module.args.desktopConfigHome or "/home/soywater/nixconfigs";
      mapleMono = pkgs.maple-mono.NF-CN;
      fontconfig = pkgs.writeText "kitty-fonts.conf" ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <dir>${mapleMono}/share/fonts</dir>
        </fontconfig>
      '';
    in
    {
      imports = [ wlib.modules.default ];
      package = pkgs.kitty;

      # Kitty explicitly selects Maple Mono NF CN, so carry both the font and
      # its Fontconfig search path in this wrapper rather than relying on a
      # system-wide font installation.
      env.FONTCONFIG_FILE = fontconfig;
      addFlag = [
        [ "--config" "${desktopConfigHome}/wrapped-applications/desktop/config/kitty/kitty.conf" ]
        "--single-instance"
      ];
    };
}
