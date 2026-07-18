{
  flake.modules.nixos.services =
    { hostName, lib, pkgs, ... }:
    {
      # Networking and remote access.
      networking.hostName = hostName;
      networking.networkmanager = {
        enable = true;
        plugins = [
          pkgs.networkmanager-openconnect
        ];
      };

      services.tailscale = {
        enable = true;
        openFirewall = true;
        useRoutingFeatures = "client";
      };

      services.openssh = {
        enable = true;
        openFirewall = false;
        settings = {
          KbdInteractiveAuthentication = false;
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

      # Audio and Bluetooth.
      services.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings.General.Experimental = true;
      };

      services.udisks2.enable = true;
      programs.nix-ld.enable = true;

      powerManagement.enable = true;
      services.thermald.enable = true;
      services.tlp = {
        enable = true;
        settings = {
          START_CHARGE_THRESH_BAT0 = 40;
          STOP_CHARGE_THRESH_BAT0 = 80;
          DEVICES_TO_ENABLE_ON_STARTUP = "bluetooth";
        };
      };
      services.power-profiles-daemon.enable = lib.mkForce false;
      services.fstrim.enable = true;
      services.fwupd.enable = true;
      services.hardware.bolt.enable = true;

      # Legion service integrations.
      services.xserver.videoDrivers = [ "nvidia" ];

      environment.systemPackages = with pkgs; [
        pavucontrol
        udiskie
        ffmpeg_7

        libXScrnSaver
        libX11
        libXcursor
        libXinerama
        libXrandr
        libXi
        libGL
        SDL2
        wayland
        zlib
        openssl
        stdenv.cc.cc
        curl
        expat

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
    };
}
