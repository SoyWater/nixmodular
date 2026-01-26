{
  flake.modules.homeManager.frankenstein=
  { config, inputs, pkgs, ... }:
  {
    home.packages = [
      inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    xdg.configFile."matugen".source = (config.lib.my.setupSymlinkRel ./matugen);
    xdg.configFile."matugen".recursive = true;
  };
}
