{ inputs, ... }:
{
  flake.nixosModules.applications = { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      voxtype = pkgs.voxtype.override {
        onnxSupport = true;
        vulkanSupport = true;
      };
      editors = pkgs.buildEnv {
        name = "editors";
        paths = with pkgs; [
          jetbrains.idea
          temurin-bin-21
          zed-editor
        ];
      };
      factorio = inputs.factorio-flake.packages.${system}.default;
      zenBrowser = inputs.zen-browser.packages.${system}.default;
    in
    {
      xdg.mime.defaultApplications = {
        "application/pdf" = "zen-beta.desktop";
      };

      environment.systemPackages = [
        pkgs.chromium
        pkgs.obsidian
        inputs.codebuddy.packages.${system}.default
        pkgs.llm-agents.codex
        pkgs.gh
        pkgs.gh-dash
        pkgs.lutris
        editors
        voxtype
        pkgs.wtype
        factorio
        zenBrowser
      ];
    };
}
