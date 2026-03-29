let
  moduleName = "cloudflared";
in
{
  flake.modules.nixos.${moduleName}=
  { pkgs, ... }:
  {
    services.cloudflared.enable = true;
    environment.systemPackages = with pkgs; [
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
