{
  flake.nixosModules.legion =
    { lib, pkgs, ... }:
    {
      networking.hostName = "legion";
      nix.settings = {
        max-jobs = 10;
        cores = 10;
      };

      system.stateVersion = "25.05";
    };
}
