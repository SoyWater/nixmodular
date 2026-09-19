{
  description = "NixOs Full Config";

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
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
    vicinae.url = "github:vicinaehq/vicinae";
    factorio-flake = {
      url = "github:Soywater-nix/factorio-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codebuddy = {
      url = "github:Soywater-nix/codebuddy-nix";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      ];

      perSystem = { config, system, ... }:
        let
          nixpkgsConfig = {
            allowUnfree = true;
          };
        in
        {
          # Make all per-system packages available to moduleWithSystem
          # consumers.  App modules can then use either `self'.packages` or
          # the existing `packages` argument without depending on an
          # aggregate feature module being imported first.
          _module.args.packages = config.packages;
            _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config = nixpkgsConfig;
          };
        };
    };
}
