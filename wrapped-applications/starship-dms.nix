{ ... }:
{
  perSystem = { lib, pkgs, ... }: {
    wrappers.control_type = lib.mkDefault "build";
    wrappers.packages.starship-dms = pkgs.stdenv.isLinux;
  };

  flake.wrappers.starship-dms = { pkgs, wlib, ... }: {
    imports = [
      wlib.modules.default
    ];
    package = pkgs.starship;
  };
}
