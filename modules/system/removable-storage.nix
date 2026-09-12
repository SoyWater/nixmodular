{ ... }:
{
  flake.nixosModules.removableStorage = { pkgs, ... }: {
    programs.fuse = {
      enable = true;
      userAllowOther = true;
    };

    services.udisks2.enable = true;

    environment.systemPackages = with pkgs; [
      udiskie
      sshfs
    ];
  };
}
