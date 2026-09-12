{ inputs, moduleWithSystem, ... }:
{
  flake.nixosModules.coreNix = moduleWithSystem ({ config, ... }: {
    imports = [ inputs.nix-index-database.nixosModules.nix-index ];

    programs.comma.enable = true;
    programs.nix-index-database.comma.enable = true;

    nix = {
      extraOptions = ''
        connect-timeout = 5
        log-lines = 50
        min-free = 128000000
        max-free = 1000000000
        fallback = true
      '';
      settings = {
        auto-optimise-store = true;
        warn-dirty = false;
        experimental-features = [ "nix-command" "flakes" ];
        extra-substituters = [
          "https://aseipp-nix-cache.freetls.fastly.net?priority=30"
          "https://nix-community.cachix.org?priority=35"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };

    nixpkgs = {
      config.allowUnfree = true;
    };

    _module.args.packages = config.packages;
  });
}
