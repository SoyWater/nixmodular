{ inputs, ... }:
{
  flake.nixosModules.applications = { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
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
      environment.systemPackages = [
        pkgs.chromium
        pkgs.obsidian
        inputs.codebuddy.packages.${system}.default
        inputs.llm-agents.packages.${system}.codex
        pkgs.gh
        pkgs.gh-dash
        pkgs.lutris
        editors
        factorio
        zenBrowser
      ];
    };
}
