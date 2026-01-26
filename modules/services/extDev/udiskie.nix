let
  moduleName = "udiskie";
in
{
  flake.modules.nixos.${moduleName}=
  { pkgs, ... }:
  {
    services.udisks2.enable = true;
    environment.systemPackages = with pkgs; [
      udiskie
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
