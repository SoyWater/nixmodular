{ inputs, ... }:
{
  flake.nixosModules.applications = { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
    in
    {
      xdg.mime.defaultApplications = {
        "application/pdf" = "zen-beta.desktop";
      };

      environment = {
        sessionVariables.LAUNCH_BROWSER = "zen-beta";
        systemPackages = [
          pkgs.chromium
          pkgs.obsidian
          inputs.codebuddy.packages.${system}.default
          pkgs.llm-agents.codex
          pkgs.gh
          pkgs.gh-dash
          pkgs.lutris
          pkgs.jetbrains.idea
          pkgs.temurin-bin-21
          pkgs.zed-editor
          inputs.factorio-flake.packages.${system}.default
          inputs.zen-browser.packages.${system}.default
        ];
      };
    };
}
