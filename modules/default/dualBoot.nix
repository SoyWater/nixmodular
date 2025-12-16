{
  flake.modules.nixos.dualBoot =
  { lib, config, pkgs, ... }:
  {
    options = {
      windows-boot-drive = lib.mkOption {
        type = lib.types.str;
        default = "FS0";
      };
    };

    config = lib.mkMerge [
    (lib.mkIf (config.bootLoader == "systemd-boot") {
      boot.loader = lib.mkIf (config.bootLoader == "systemd-boot") {
        systemd-boot = {
          enable = true;

          windows = {
            "windows" =
                # To determine the name of the windows boot drive, boot into edk2 first, then run
                # `map -c` to get drive aliases, and try out running `FS1:`, then `ls EFI` to check
                # which alias corresponds to which EFI partition.
              {
                title = "Windows";
                efiDeviceHandle = config.windows-boot-drive;
                sortKey = "a_windows";
              };
          };

          edk2-uefi-shell.enable = true;
          edk2-uefi-shell.sortKey = "z_edk2";
        };
      };
    })

    (lib.mkIf (config.bootLoader == "limine") {
      boot.loader.limine.extraConfig= ''
        default_entry: 3
        /Windows
          protocol: efi
          path: uuid(1591abd5-1f7e-492d-bc69-f133029d011a):/EFI/Microsoft/Boot/bootmgfw.efi
      '';

    })
    ];
  };
}
