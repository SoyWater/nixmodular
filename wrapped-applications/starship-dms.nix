{ ... }:
{
  flake.wrappers.starship-dms = { pkgs, wlib, ... }: {
    imports = [
      wlib.modules.default
    ];
    package = pkgs.starship;
  };
}
