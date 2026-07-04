{ ... }:
{
  perSystem = { inputs', pkgs, pkgsCodex, ... }: {
    packages.codex = pkgs.symlinkJoin {
      name = "codex";
      paths = [
        pkgsCodex.codex
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
    packages.factorio = inputs'.factorio-flake.packages.default;

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
    packages.neovim = inputs'.nvim.packages.default;
    packages.sops = pkgs.symlinkJoin {
      name = "sops";
      paths = [
        pkgs.sops
      ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/sops \
          --set SOPS_AGE_SSH_PRIVATE_KEY_CMD "/run/wrappers/bin/sudo ${pkgs.coreutils}/bin/cat /etc/ssh/ssh_host_ed25519_key"
      '';
    };
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
    packages.zoom = pkgs.zoom-us;
  };
}
