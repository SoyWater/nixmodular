{ ... }:
{
  perSystem = { inputs', pkgs, ... }: {
    packages.codex = pkgs.symlinkJoin {
      name = "codex";
      paths = [
        pkgs.codex
      ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/codex \
          --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.bubblewrap ]}
      '';
    };

    packages.editors = pkgs.buildEnv {
      name = "editors";
      paths = with pkgs; [
        jetbrains.idea
        temurin-bin-21
        zed-editor
      ];
    };

    packages.forticlient =
      let
        openfortivpnConfig = pkgs.writeText "openfortivpn-nus.conf" ''
          host = webvpn.comp.nus.edu.sg
          port = 443
        '';
      in
      pkgs.writeShellApplication {
          name = "openfortivpn";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.gnugrep
            pkgs.xdg-utils
          ];
          text = ''
            opened=0

            set +e
            /run/wrappers/bin/sudo ${pkgs.coreutils}/bin/stdbuf -oL -eL \
              ${pkgs.openfortivpn}/bin/openfortivpn \
              -c ${openfortivpnConfig} \
              --saml-login \
              "$@" \
              2>&1 | while IFS= read -r line; do
                printf '%s\n' "$line"

                if [ "$opened" -eq 0 ]; then
                  url="$(printf '%s\n' "$line" | grep -oE 'https://[^[:space:]'"'"']+' | head -n 1 || true)"

                  if [ -n "$url" ]; then
                    xdg-open "$url" >/dev/null 2>&1 &
                    opened=1
                  fi
                fi
              done
            status=''${PIPESTATUS[0]}
            set -e

            exit "$status"
          '';
        };
    packages.gh-dash = pkgs.gh-dash;
    packages.lutris = pkgs.lutris;
    packages.minecraft = pkgs.prismlauncher.override {
      jdks = with pkgs; [
        jdk21
        jdk17
        jdk8
        temurin-bin-25
      ];
    };
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
    packages.zoom = pkgs.zoom-us;
  };
}
