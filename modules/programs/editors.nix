let
  moduleName = "editors";
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
      jetbrains.idea
      temurin-bin-21
      zed-editor
    ];

    imports = [
    ];
  };
}
