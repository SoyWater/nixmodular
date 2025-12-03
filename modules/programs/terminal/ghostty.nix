{ lib, config, ... }:

{
  options = {
    ghostty.enable = lib.mkEnableOption {
      name = "enable ghostty";
      default = true;
    };
  };

  config = lib.mkIf config.ghostty.enable {
    programs.ghostty.enable = true;
    programs.ghostty.enableFishIntegration = config.fish.enable;
    home.services."app-com.mitchellh.ghostty".enable = true;
  };
}
