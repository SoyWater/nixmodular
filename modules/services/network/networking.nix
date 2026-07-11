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

  };
}
