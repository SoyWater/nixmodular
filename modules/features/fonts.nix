{ ... }:
{
  flake.nixosModules.fonts = { pkgs, ... }: {
    fonts = {
      packages = [ pkgs.maple-mono.NF-CN ];
      fontconfig.defaultFonts.monospace = [ "Maple Mono NF CN" ];
    };
  };
}
