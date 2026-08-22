{
  flake.nixosModules.legion =
    { packages, pkgs, ... }:
    {
      environment.systemPackages = [
        packages.compress
        pkgs.gh
        pkgs.codex
        packages.editors
        packages.factorio
        packages.gh-dash
        packages.lutris
        packages.minecraft
        packages.neovim
        packages.zen-browser-wayland
        packages.zoom
        pkgs.chromium
      ];

      programs.comma.enable = true;

      networking.hostName = "legion";
      xdg.mime.defaultApplications = {
        "application/pdf" = "zen-beta.desktop";
      };

      system.stateVersion = "25.05";
    };
}
