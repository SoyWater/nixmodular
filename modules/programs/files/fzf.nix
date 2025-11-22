{ lib, config, ... }:

{
  options = {
    fzf.enable = lib.mkEnableOption {
      name = "enable fzf";
      default = true;
    };
  };

  config = lib.mkIf config.fzf.enable {
    programs.fzf.enable = true;
    programs.fzf.enableFishIntegration = config.fish.enable;
  };
}
