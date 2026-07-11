{ ... }:
{
  perSystem = { inputs', pkgs, ... }: {
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
    packages.neovim = inputs'.nvim.packages.default;
    packages.zoom = pkgs.zoom-us;
  };
}
