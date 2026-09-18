{
  flake.nixosModules.sandboxing =
    { pkgs, ... }:
    {
      # AppImages are not sandboxed; this only supplies the FHS compatibility
      # environment they need on NixOS and lets executable .AppImage files run directly.
      programs.appimage = {
        enable = true;
        binfmt = true;
        package = pkgs.appimage-run.override {
          extraPkgs = pkgs: [ pkgs.libayatana-appindicator ];
        };
      };

      services.flatpak.enable = true;

      # Make Flathub available system-wide for imperative Flatpak installs.
      systemd.services.flatpak-flathub = {
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.flatpak ];
        script = ''
          flatpak remote-add --if-not-exists --system flathub \
            https://dl.flathub.org/repo/flathub.flatpakrepo
        '';
      };
    };
}
