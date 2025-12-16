{
  flake.modules.nixos.baseConfig =
  { config, lib, pkgs, ... }:
  {
    options = {
      bootLoader = lib.mkOption {
        type = lib.types.enum [ "systemd-boot" "limine" ];
        default = "systemd-boot";
      };
      limine.secureBoot = lib.mkEnableOption {
        name = "Enable limine secure boot";
        default = false;
      };
    };

    config = {
      boot.loader = lib.mkMerge [
        (lib.mkIf (config.bootLoader == "systemd-boot") {
          systemd-boot.enable = true;
        })

        (lib.mkIf (config.bootLoader == "limine") {
          limine.enable = true;
          limine.efiSupport = true;          
          limine.maxGenerations = 10;

          limine.secureBoot.enable = config.limine.secureBoot;
        })
      ];
      environment.systemPackages = [ (lib.mkIf (config.limine.secureBoot) pkgs.sbctl) ];
    };
  };
}
