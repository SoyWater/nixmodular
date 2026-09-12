{ inputs, ... }:
{
  flake.nixosModules.applications = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.chromium
      pkgs.obsidian
      inputs.codebuddy.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.codex
      pkgs.gh
      pkgs.gh-dash
      pkgs.lutris
    ];
  };
}
