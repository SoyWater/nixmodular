{
  description = "NixOs Full Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, nix-index-database, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
       	config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
      hostDir = ./hosts;
      hosts = builtins.filter (x: x != null) (lib.mapAttrsToList (name: value: if (value == "directory") then name else null) (builtins.readDir hostDir));
    in
    {
      nixosConfigurations = builtins.listToAttrs (map 
      	(host: {
          name = host;
      	  value = lib.nixosSystem {
      	    modules = [

      	      (hostDir + "/${host}")
      	      ./modules

      	      home-manager.nixosModules.home-manager {
      	        home-manager.extraSpecialArgs = { inherit self inputs; };
      	        home-manager.useGlobalPkgs = true;
             		home-manager.useUserPackages = true;
              }

      	    ];

            specialArgs = {
      	      inherit inputs system host;
      	    };
      	  };
	  
      	}) 
      	hosts
      );

      homeManagerModules.default = ./modules/programs;
    };
}
