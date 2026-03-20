let
  moduleName = "zen-browser";
in
{
  flake.modules.nixos.${moduleName}=
  { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [
    ];

    imports = [
    ];

    xdg.mime.defaultApplications = {
      "application/pdf" = "zen-beta.desktop";
    };
  };

  flake.modules.homeManager.${moduleName} =
  { inputs, pkgs, ... }:
  let
    zenFixed = inputs.zen-browser.packages."${pkgs.system}".default.overrideAttrs (
      old: {
        nativeBuildInputs = [
          pkgs.makeWrapper
          pkgs.copyDesktopItems
          pkgs.wrapGAppsHook3
        ];
      }
    );

    zenWithWayland = pkgs.symlinkJoin {
      name = "zen-browser-wayland";
      paths = [ zenFixed ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/zen \
          --set MOZ_ENABLE_WAYLAND 1
      '';
     };
  in
  {
    home.packages = [ zenWithWayland ];

  };
}
