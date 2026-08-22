{
  description = "NixOs Full Config";

  nixConfig = {
    extra-substituters = [
      "https://custom-nix-applications.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "custom-nix-applications.cachix.org-1:PK67OYpIq7614gth55JteSG/U2Q1DKqDAN/Wb+rEzOY="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae.url = "github:vicinaehq/vicinae";
    factorio-flake = {
      url = "github:SoyWater/factorio-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    custom-applications = {
      url = "github:SoyWater/custom-nix-applications";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim = {
      url = "./nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follow = "nixpkgs";
    }
  };

  outputs = { flake-parts, import-tree, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } 
    { 
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      imports = [
        inputs.wrappers.flakeModules.wrappers
        (import-tree ./modules)
        (import-tree ./wrapped-applications)
      ];

      perSystem = { system, ... }:
        let
          nixpkgsConfig = {
            allowUnfree = true;
          };
        in
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.custom-applications.overlays.default
            ];
            config = nixpkgsConfig;
          };
        };
    };
}
