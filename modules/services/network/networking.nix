{
  flake.modules.nixos.networking=
  { hostName, ...}:
  {
    networking.hostName = hostName;
    networking.networkmanager = {
      enable = true;
    };
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "client";
    };

  };
}
