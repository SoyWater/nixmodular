{
  flake.nixosModules.coreBoot =
  { config, lib, pkgs, ... }:
  {
    options = {
      bootLoader = lib.mkOption {
        type = lib.types.enum [ "systemd-boot" "limine" ];
        default = "limine";
      };
      limine.secureBoot = lib.mkOption {
        type = lib.types.bool;
        default = true;
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
          limine.efiInstallAsRemovable = true;
          limine.maxGenerations = 10;
          limine.extraInstallCommands = ''
            ${pkgs.coreutils}/bin/install -Dm700 ${config.boot.loader.efi.efiSysMountPoint}/EFI/BOOT/BOOTX64.EFI \
              ${config.boot.loader.efi.efiSysMountPoint}/EFI/limine/BOOTX64.EFI
          '';
          limine.secureBoot.enable = config.limine.secureBoot;
        })
      ];
      environment.systemPackages = [ (lib.mkIf (config.limine.secureBoot) pkgs.sbctl) ];
    };
  };
}
