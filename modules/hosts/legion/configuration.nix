{ config, ...}:
{
  flake.system."legion" = "x86_64-linux";
  flake.modules.nixos."hosts/legion" =
  { pkgs, packages, ... }:
  {
    
    imports = with config.flake.modules.nixos; [
      baseConfig
      desktop
      networking
      ghostty
      dualBoot
      bluetooth
      pipewire
      power
      docker
      fonts
      ffmpeg
      udiskie
      nixld
      virtman

      # user
      soywater
    ] ++ [
      {
        home-manager.users.soywater.imports = with config.flake.modules.homeManager; [
          baseConfig
          ghostty
          direnv
        ];
      }
    ];

    environment.systemPackages = [
      packages.compress
    ];

    nix.settings = {
      extra-substituters = [
        "https://aseipp-nix-cache.freetls.fastly.net?priority=30"
        "https://nix-community.cachix.org?priority=35"
        "https://custom-nix-applications.cachix.org?priority=40"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "custom-nix-applications.cachix.org-1:PK67OYpIq7614gth55JteSG/U2Q1DKqDAN/Wb+rEzOY="
      ];
    };

    xdg.mime.defaultApplications = {
      "application/pdf" = "zen-beta.desktop";
    };

    users.users.soywater.packages = [
      pkgs.codex
      packages.editors
      packages.factorio
      packages.gh-dash
      packages.lutris
      packages.minecraft
      packages.neovim
      packages.zen-browser-wayland
      packages.zoom
      pkgs.chromium
    ];

    services.qbittorrent.enable = true;
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
