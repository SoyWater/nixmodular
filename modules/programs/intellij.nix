let
  moduleName = "intellij";
in
{
  flake.modules.nixos.${moduleName}=
  { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [
    ];

    imports = [
    ];
  };

  flake.modules.homeManager.${moduleName} =
  { pkgs, ... }:
  {
    home.packages = with pkgs; [
      jetbrains.idea-ultimate
      temurin-bin-21
    ];

    imports = [
    ];
  };
}
