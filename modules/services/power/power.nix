{
  flake.modules.nixos.power =
  { ... }:
  {
    services.thermald.enable = true;
    services.tlp = {
      enable = false;
      settings = {
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
        DEVICES_TO_ENABLE_ON_STARTUP = "bluetooth";
      };
    };
  };
}
