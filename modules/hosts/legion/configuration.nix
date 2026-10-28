{
  flake.nixosModules.legion =
    { lib, pkgs, ... }:
    {
      networking.hostName = "legion";
      services.teamviewer.enable = true;
      nix.settings = {
        max-jobs = 10;
        cores = 10;
      };

      system.stateVersion = "25.05";
    };
}
