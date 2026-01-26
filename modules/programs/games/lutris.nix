{
  flake.modules.nixos.lutris =
  { ... }:
  {
    
  };

  flake.modules.homeManager.lutris =
  { pkgs, ... }:
  {
    home.packages = with pkgs; [
      lutris
    ];

  };
}
