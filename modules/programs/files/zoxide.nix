{ lib, config, ... }:

{
  options = {
    zoxide.enable = lib.mkEnableOption {
      name = "enable zoxide";
      default = true;
    };
  };

  config = lib.mkIf config.zoxide.enable {
    programs.zoxide.enable = true;
    programs.zoxide.enableFishIntegration = config.fish.enable;
  };
}
