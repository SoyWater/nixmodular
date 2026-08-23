{
  flake.nixosModules.legion =
    { packages, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ gh codex chromium ];

      programs.comma.enable = true;

      networking.hostName = "legion";
      xdg.mime.defaultApplications = {
        "application/pdf" = "zen-beta.desktop";
      };

      system.stateVersion = "25.05";
    };
}
