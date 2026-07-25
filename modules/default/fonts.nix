let
  moduleName = "fonts";
in
{
  flake.modules.nixos.${moduleName}=
  { pkgs, ... }:
  {
    fonts.packages = with pkgs; [
      maple-mono.NF-CN
    ];

    fonts.fontconfig.defaultFonts = {
      serif = [ "Maple Mono NF CN" ];
      sansSerif = [ "Maple Mono NF CN" ];
      monospace = [ "Maple Mono NF CN" ];
      emoji = [ "Maple Mono NF CN" ];
    };

    imports = [
    ];
  };

  flake.modules.homeManager.${moduleName} =
  { pkgs, ... }:
  {
    home.packages = with pkgs; [
    ];

    imports = [
    ];
  };
}
