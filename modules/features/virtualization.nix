{
  flake.modules.nixos.virtualization =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        dnsmasq
      ];

      networking.firewall.trustedInterfaces = [ "virbr0" ];

      virtualisation = {
        docker = {
          enable = true;
          autoPrune = {
            enable = true;
            dates = "weekly";
            flags = [
              "--volumes"
              "--all"
            ];
          };
          daemon.settings.features.cdi = true;
          enableNvidia = true;
        };

        libvirtd = {
          enable = true;
          qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
        };
      };

      hardware.nvidia-container-toolkit = {
        enable = true;
        suppressNvidiaDriverAssertion = true;
      };

      programs.virt-manager.enable = true;
    };
}
