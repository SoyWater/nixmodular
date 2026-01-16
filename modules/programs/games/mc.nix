{
  flake.modules.nixos.minecraft =
  { ... }:
  {
    
  };

  flake.modules.homeManager.minecraft =
  { pkgs, ... }:
  {
    home.packages = with pkgs; [
      prismlauncher
    ];

  };
}
