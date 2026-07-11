{ ... }:
{
  flake.wrappers.ghostty-dms = { pkgs, wlib, ... }: {
    imports = [
      wlib.modules.default
    ];
    package = pkgs.ghostty;
  };
}
