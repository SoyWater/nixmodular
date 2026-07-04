{
  flake.modules.nixos.networking=
  { hostName, pkgs, ...}:
  {
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

  };
}
