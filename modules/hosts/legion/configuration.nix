{
  flake.nixosModules.legion =
    { pkgs, ... }:
    {
      programs.comma.enable = true;
      programs.nix-index-database.comma.enable = true;

      networking.hostName = "legion";
      xdg.mime.defaultApplications = {
        "application/pdf" = "zen-beta.desktop";
      };

      system.stateVersion = "25.05";
    };
}
