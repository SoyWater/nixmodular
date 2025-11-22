{ lib, config, ... }:

{
  options = {
    yazi.enable = lib.mkEnableOption {
      name = "enable yazi";
      default = true;
    };
  };

  config = lib.mkIf config.yazi.enable {
    programs.yazi.enable = true;
    programs.yazi.enableFishIntegration = config.fish.enable;
  };
}
