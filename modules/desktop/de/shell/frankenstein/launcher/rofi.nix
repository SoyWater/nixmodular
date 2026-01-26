{
  flake.modules.homeManager.frankenstein=
  { pkgs, ... }:
  {
    home.packages = [
      pkgs.rofi
    ];
  };
}
