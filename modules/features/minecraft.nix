{ moduleWithSystem, ... }:
{
  perSystem = { pkgs, ... }: {
    packages.minecraft = pkgs.prismlauncher.override {
      jdks = with pkgs; [
        jdk21
        jdk17
        jdk8
        temurin-bin-25
      ];
    };
  };

  flake.nixosModules.minecraft = moduleWithSystem ({ packages, ... }: {
    environment.systemPackages = [ packages.minecraft ];
  });
}
