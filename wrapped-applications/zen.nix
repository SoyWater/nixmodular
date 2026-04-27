{ ... }:
{
  perSystem = { inputs', pkgs, ... }: {
    packages.zen-browser-wayland =
      let
        zenFixed = inputs'.zen-browser.packages.default.overrideAttrs (old: {
          nativeBuildInputs =
            (old.nativeBuildInputs or [ ])
            ++ [
              pkgs.makeWrapper
              pkgs.copyDesktopItems
              pkgs.wrapGAppsHook3
            ];
        });
      in
      pkgs.symlinkJoin {
        name = "zen-browser-wayland";
        paths = [ zenFixed ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/zen \
            --set MOZ_ENABLE_WAYLAND 1
        '';
      };
  };
}
