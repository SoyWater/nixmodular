let
  moduleName = "virtman";
in
{
  flake.modules.nixos.${moduleName}=
  { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [
      dnsmasq
    ];

    networking.firewall.trustedInterfaces = [ "virbr0" ];

    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };

    programs.virt-manager.enable = true;

    imports = [
    ];
  };

  flake.modules.homeManager.${moduleName} =
  { pkgs, ... }:
  {
    home.packages = with pkgs; [
    ];

    imports = [
    ];
  };
}
