{ config, ...}:
{
  flake.system."legion" = "x86_64-linux";
  flake.modules.nixos."hosts/legion" =
  { pkgs, inputs, packages, ... }:
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
      fonts
      ffmpeg
      udiskie
      nixld
      wireshark
      cloudflared
      virtman

      # user
      soywater
    ] ++ [
      {
        home-manager.users.soywater.imports = with config.flake.modules.homeManager; [
          baseConfig
          niri
          ghostty
          direnv
          minecraft
          lutris
          gh-dash
          opencode
          factorio
          forticlient
          editors
          codex
          zoom
        ];
      }
    ] ++ [
      inputs.nixos-hardware.nixosModules.lenovo-legion-16iax10h
    ];

    environment.systemPackages = [
      packages.compress
    ];

    xdg.mime.defaultApplications = {
      "application/pdf" = "zen-beta.desktop";
    };

    home-manager.users.soywater.home.packages = [
      packages.zen-browser-wayland
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

    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
