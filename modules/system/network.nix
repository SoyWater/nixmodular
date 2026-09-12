{ ... }:
{
  flake.nixosModules.network =
  { pkgs, lib, ... }:
  {
    networking = {
      networkmanager = {
        enable = true;
        plugins = with pkgs; [
          networkmanager-openconnect
        ];
      };
      firewall.enable = false;
      useDHCP = lib.mkDefault true;
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

    environment.systemPackages = [
      pkgs.networkmanagerapplet
      pkgs.sshpass
    ];

    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
