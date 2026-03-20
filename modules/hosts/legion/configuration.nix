{ config, ...}:
{
  flake.modules.nixos."hosts/legion" =
  { pkgs, inputs, ... }:
  {
    
    imports = with config.flake.modules.nixos; [
      baseConfig
      niri
      networking
      ghostty
      dualBoot
      bluetooth
      pipewire
      power
      docker
      dms
      compression
      fonts
      ffmpeg
      udiskie
      nixld
      wireshark
      zen-browser

      # user
      soywater
    ] ++ [
      {
        home-manager.users.soywater.imports = with config.flake.modules.homeManager; [
          baseConfig
          niri
          ghostty
          zen-browser
          direnv
          minecraft
          lutris
          gh-dash
          opencode
          factorio
          forticlient
          intellij
        ];
      }
    ] ++ [
      inputs.nixos-hardware.nixosModules.lenovo-legion-16iax10h
    ];

    hardware.enableAllFirmware = true;
    hardware.nvidia.modesetting.enable = true;
    boot.kernelParams = [ "usbhid.quirks=048d:c195:0x0004" ];
    hardware.firmware = [ pkgs.linux-firmware ];
    windows-boot-drive = "FS0";
    bootLoader = "limine";
    limine.secureBoot = true;

    systemd.tmpfiles.rules = [
      "w /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode - - - - 1"
    ];


    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
