let
  moduleName = "nixld";
in
{
  flake.modules.nixos.${moduleName}=
  { pkgs, ... }:
  {
    programs.nix-ld.enable = true;
    environment.systemPackages = with pkgs; [
      xorg.libXScrnSaver
        xorg.libX11
        xorg.libXcursor
        xorg.libXinerama
        xorg.libXrandr
        xorg.libXi
        libGL
        SDL2
        wayland
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
