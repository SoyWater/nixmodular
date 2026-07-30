{
  flake.modules.nixos.sunshine = {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;

      # Keep Sunshine private to the explicitly allowed Tailscale interface.
      openFirewall = false;
    };

    networking.firewall.interfaces.tailscale0 = {
      allowedTCPPorts = [
        47984
        47989
        47990
        48010
      ];
      allowedUDPPorts = [
        47998
        47999
        48000
        48002
        48010
      ];
    };
  };
}
