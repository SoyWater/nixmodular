let
  moduleName = "fonts";
in
{
  flake.modules.nixos.${moduleName}=
  { pkgs, ... }:
  {
    fonts.packages = with pkgs; [
      fira
      noto-fonts-cjk-sans
      nerd-fonts.jetbrains-mono
    ];

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
