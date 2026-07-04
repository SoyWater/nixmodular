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
