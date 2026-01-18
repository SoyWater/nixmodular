{
  flake.modules.nixos.networking=
  { hostName, ...}:
  {
    networking.hostName = hostName;
    networking.networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };
}
