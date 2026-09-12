{ ... }:
{
  flake.nixosModules.graphics = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      libXScrnSaver
      libX11
      libXcursor
      libXinerama
      libXrandr
      libXi
      libGL
      SDL2
      wayland
      mesa-demos
      vulkan-tools
      libva-utils
    ];
  };
}
