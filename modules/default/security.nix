{
  flake.modules.nixos.baseConfig = {
    security.sudo.wheelNeedsPassword = false;
    security.polkit.enable = true;
    security.rtkit.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
