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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";
    systems.url = "github:nix-systems/default";
  };

  outputs = { flake-parts, import-tree, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (import-tree ./modules);

    # let
    #   system = "x86_64-linux";
    #   pkgs = import nixpkgs {
    #     inherit system;
    #    	config.allowUnfree = true;
    #   };
    #   lib = nixpkgs.lib;
    #   hostDir = ./hosts;
    #   hosts = builtins.filter (x: x != null) (lib.mapAttrsToList (name: value: if (value == "directory") then name else null) (builtins.readDir hostDir));
    # in
    # {
    #   nixosConfigurations = builtins.listToAttrs (map 
    #   	(host: {
    #       name = host;
    #   	  value = lib.nixosSystem {
    #   	    modules = [

    #   	      (hostDir + "/${host}")
    #   	      ./modules

    #   	      home-manager.nixosModules.home-manager {
    #   	        home-manager.extraSpecialArgs = { inherit self inputs; };
    #   	        home-manager.useGlobalPkgs = true;
    #          		home-manager.useUserPackages = true;
    #           }

    #   	    ];

    #         specialArgs = {
    #   	      inherit inputs system host;
    #   	    };
    #   	  };
	  
    #   	}) 
    #   	hosts
    #   );

    #   homeManagerModules.default = ./modules/programs;
    # };
}
