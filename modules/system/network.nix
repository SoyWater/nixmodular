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

    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
