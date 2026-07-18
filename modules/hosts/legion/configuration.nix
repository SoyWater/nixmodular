{ config, ...}:
{
  flake.system."legion" = "x86_64-linux";
  flake.modules.nixos."hosts/legion" =
  { pkgs, packages, ... } @ nixosArgs:
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

    # Keep the host package set aligned with the selected kernel and provide
    # the hardware diagnostics/tools needed on Legion.
    environment.systemPackages = with pkgs; [
      packages.compress
      nixosArgs.config.boot.kernelPackages.kernel.dev

      usbutils
      dmidecode
      mesa-demos
      vulkan-tools
      libva-utils
      nvme-cli
      smartmontools
      lm_sensors
      powertop
      fwupd
      bolt
      alsa-utils
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

    # Use the newest kernel/driver pair available in the selected nixpkgs.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.qbittorrent.enable = true;
    hardware.nvidia.modesetting.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      open = true;
      nvidiaSettings = true;
      package = nixosArgs.config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      prime = {
        intelBusId = "PCI:00:02:0";
        nvidiaBusId = "PCI:02:00:0";
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };

    powerManagement.enable = true;
    services.thermald.enable = true;
    services.fwupd.enable = true;
    services.hardware.bolt.enable = true;
    services.fstrim.enable = true;

    hardware.bluetooth.settings = {
      General.Experimental = true;
    };

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
