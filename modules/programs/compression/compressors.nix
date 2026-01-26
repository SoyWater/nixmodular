let
  moduleName = "compression";
in
{
  flake.modules.nixos.${moduleName}=
  { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [
      (writeShellApplication {
        name = "extract";
        runtimeInputs = [
          zip
          unzip
          p7zip
          unrar
        ];
        text = builtins.readFile ./extract.sh;
      })
      (writeShellApplication {
        name = "compress";
        runtimeInputs = [
          zip
          unzip
          p7zip
          unrar
        ];
        text = builtins.readFile ./compress.sh;
      })
    ];

    imports = [
    ];
  };

  flake.modules.homeManager.${moduleName} =
  { pkgs, ... }:
  {
    home.packages = with pkgs; [
    ];

    imports = [
    ];
  };
}
