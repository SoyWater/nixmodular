{ ... }:
{
  perSystem = { inputs', pkgs, ... }: {
    packages.zen-browser-wayland =
      let
        zenFixed = inputs'.zen-browser.packages.default;
        zenMainProgram = zenFixed.meta.mainProgram or "zen";
      in
      pkgs.symlinkJoin {
        name = "zen-browser-wayland";
        paths = [ zenFixed ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/${zenMainProgram} \
            --set MOZ_ENABLE_WAYLAND 1
        '';
      };
  };
}
