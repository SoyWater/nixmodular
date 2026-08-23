{ moduleWithSystem, ... }:
{
  perSystem = { pkgs, ... }:
    let
      runtimeArchiveTools = with pkgs; [
        zip
        unzip
        p7zip
        unrar
        gnutar
        gzip
        bzip2
      ];

      compressCommand = pkgs.writeShellApplication {
        name = "compress";
        runtimeInputs = runtimeArchiveTools;
        text = builtins.readFile ./compress.sh;
      };

      extractCommand = pkgs.writeShellApplication {
        name = "extract";
        runtimeInputs = runtimeArchiveTools;
        text = builtins.readFile ./extract.sh;
      };
    in
    {
      packages.compress = pkgs.buildEnv {
        name = "compression";
        paths = runtimeArchiveTools ++ [ compressCommand extractCommand ];
        pathsToLink = [ "/bin" ];
      };
    };

  flake.nixosModules.compression = moduleWithSystem ({ config, ... }: {
    environment.systemPackages = [ config.packages.compress ];
  });
}
