{
  description = "NixOs Full Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awww.url = "git+https://codeberg.org/LGFae/awww";
    matugen.url = "github:/InioX/Matugen";

    import-tree.url = "github:vic/import-tree";

    factorio-flake = {
      url = "github:SoyWater/factorio-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { flake-parts, import-tree, ... } @ inputs:
    let
      openldapNoChecksOverlay = final: prev: {
        openldap = prev.openldap.overrideAttrs (_: {
          doCheck = false;
        });
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } 
    { 
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      imports = [
        inputs.flake-parts.flakeModules.modules         
        ./nixos-hosts.nix
        (import-tree ./modules)
        (import-tree ./wrapped-applications)
      ];

      perSystem = { system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            openldapNoChecksOverlay
            inputs.niri.overlays.niri
          ];
          config = {
            allowUnfree = true;
          };
        };
      };
    };
}
