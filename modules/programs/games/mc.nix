{
  flake.modules.nixos.minecraft =
  { ... }:
  {
    
  };

  flake.modules.homeManager.minecraft =
  { pkgs, ... }:
  {
    home.packages = with pkgs; [
      (prismlauncher.override {
        jdks = [
          jdk21
          jdk17
          jdk8
          temurin-bin-25
        ];
      })
    ];

  };
}
