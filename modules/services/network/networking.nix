{
  flake.modules.nixos.networking=
  { hostConfig, ...}:
  {
    networking.hostName = hostConfig.name;
    networking.networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };
}
