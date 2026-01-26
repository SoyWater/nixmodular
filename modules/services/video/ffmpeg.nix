let
  moduleName = "ffmpeg";
in
{
  flake.modules.nixos.${moduleName}=
  { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [
      ffmpeg_7
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
