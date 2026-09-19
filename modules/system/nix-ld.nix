{ moduleWithSystem, ... }:
{
  flake.nixosModules.nix-ld = moduleWithSystem(
    { pkgs, ...}: {
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        util-linux
        stdenv.cc.cc
        zlib
        libusb1
        libglvnd
        libxkbcommon
        wayland
        libx11
        libxcursor
        libxi
        libxinerama
        libxrandr
      ];
    }
  );
}
