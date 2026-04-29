{
  flake.modules.nixos.ghostty = {
    systemd.user.services."app-com.mitchellh.ghostty.service".wantedBy = [ "default.target" ];
  };

  flake.modules.homeManager.ghostty =
  { pkgs, ... }:
  {
    programs.ghostty.enable = true;
    programs.ghostty.systemd.enable = true;
    programs.ghostty.enableFishIntegration = true;
    programs.ghostty.settings = {
      theme = "dankcolors";
      font-family = "JetBrainsMono Nerd Font";
      window-decoration = "none";
      window-padding-x = 14;
      window-padding-y = 10;
      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "10m";
      command = "${pkgs.fish}/bin/fish";
    };
  };
}
