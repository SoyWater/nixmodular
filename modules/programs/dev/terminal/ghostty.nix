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
      theme = "Catppuccin Mocha";
      window-decoration = "none";
      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "10m";
      command = "${pkgs.fish}/bin/fish";
    };
  };
}
