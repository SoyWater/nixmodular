{
  flake.nixosModules.legion =
    { lib, pkgs, ... }:
    {
      networking.hostName = "legion";
      nix.settings = {
        max-jobs = 10;
        cores = 10;
      };
      environment.sessionVariables = {
        EDITOR = "hx";
        VISUAL = "hx";
      };
      xdg.portal.config.niri."org.freedesktop.impl.portal.FileChooser" =
        lib.mkForce [ "gtk" ];

      system.stateVersion = "25.05";
    };
}
