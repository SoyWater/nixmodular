{ inputs, lib, config, withSystem, ... }:

let
  prefix = "hosts/";
  hosts = lib.filterAttrs
    (name: _: lib.hasPrefix prefix name)
    config.flake.modules.nixos;
in
{
  flake.nixosConfigurations = lib.mapAttrs'
    (name: module:
      let
        hostName = lib.removePrefix prefix name;
        system = config.flake.system.${hostName};
        specialArgs = withSystem system ({ config, ... }: {
          inherit inputs hostName;
          packages = config.packages;
        });
      in {
        name = hostName;
        value = inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            module

            inputs.nixpkgs.nixosModules.readOnlyPkgs
            ({ ... }: { nixpkgs.pkgs = withSystem system ({ pkgs, ... }: pkgs); } )

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
    	        home-manager.useGlobalPkgs = true;
           		home-manager.useUserPackages = true;
            }
          ];
        };
      }
    )
    hosts;
  
}
