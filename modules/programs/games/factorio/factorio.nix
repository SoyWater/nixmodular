let
  moduleName = "factorio";
in
{
  flake.modules.nixos.${moduleName}=
  { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [
    ];

    imports = [
    ];
  };

  flake.modules.homeManager.${moduleName} =
  { pkgs, config, ... }:
  {
    home.packages = with pkgs; [
    ];

    imports = [
      ./_factorioModule.nix
    ];
    programs.factorio.dataDirectory = "${config.home.homeDirectory}/Games";
  };
}
