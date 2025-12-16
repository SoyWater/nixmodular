{ inputs, lib, config, ... }:

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
        specialArgs = {
          inherit inputs;
          hostConfig = module // {
            name = lib.removePrefix prefix name;
          };
        };
      in {
        name = hostName;
        value = inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = module.imports ++ [
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
