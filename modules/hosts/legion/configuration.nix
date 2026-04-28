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
          opencode
        ];
      }
    ] ++ [
      inputs.nixos-hardware.nixosModules.lenovo-legion-16iax10h
    ];

    environment.systemPackages = [
      packages.compress
    ];

    nix.settings = {
      extra-substituters = [
        "https://aseipp-nix-cache.freetls.fastly.net?priority=30"
        "https://nix-community.cachix.org?priority=35"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    xdg.mime.defaultApplications = {
      "application/pdf" = "zen-beta.desktop";
    };

    users.users.soywater.packages = [
      packages.codex
      packages.editors
      packages.factorio
      packages.forticlient
      packages.gh-dash
      packages.lutris
      packages.minecraft
      packages.zen-browser-wayland
      packages.zoom
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
