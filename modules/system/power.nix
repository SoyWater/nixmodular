{ ... }:
{
  flake.nixosModules.power = { lib, pkgs, ... }: {
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

    environment.systemPackages = [ pkgs.powertop ];
  };
}
