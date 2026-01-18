{
  flake.modules.homeManager.awww=
  { inputs, pkgs, ... }:
  {
    home.packages = [
      inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    ];
  };
}
