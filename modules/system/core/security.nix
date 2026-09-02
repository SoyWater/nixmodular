{
  flake.nixosModules.coreSecurity = {
    security.sudo.wheelNeedsPassword = false;
    security.polkit.enable = true;
    security.rtkit.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    security.polkit.enablePkexecWrapper = true;
  };
}
