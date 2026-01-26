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
        ];
      }
    ] ++ [
      inputs.nixos-hardware.nixosModules.lenovo-legion-16iax10h
    ];

    hardware.enableAllFirmware = true;
    boot.kernelParams = [ "usbhid.quirks=048d:c195:0x0004" ];
    hardware.firmware = [ pkgs.linux-firmware ];
    windows-boot-drive = "FS0";
    bootLoader = "limine";
    limine.secureBoot = true;


    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
