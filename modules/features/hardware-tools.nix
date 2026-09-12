{ ... }:
{
  flake.nixosModules.hardwareTools = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      usbutils
      dmidecode
      nvme-cli
      smartmontools
      lm_sensors
    ];
  };
}
