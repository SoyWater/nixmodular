{ ... }:
{
  flake.nixosModules.media = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.ffmpeg_7 ];
  };
}
