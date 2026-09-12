{
  flake.nixosModules.legion =
    { lib, pkgs, ... }:
    {
      networking.hostName = "legion";
      environment.sessionVariables = {
        EDITOR = "hx";
        VISUAL = "hx";
      };
      xdg.mime.defaultApplications = {
        "application/pdf" = "zen-beta.desktop";
      };
      xdg.portal.config.niri."org.freedesktop.impl.portal.FileChooser" =
        lib.mkForce [ "gtk" ];

      system.stateVersion = "25.05";
    };
}
