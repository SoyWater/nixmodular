{ pkgs, username, inputs, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/" + username;
  home.stateVersion = "25.05";
 
  imports = [
    inputs.self.outputs.homeManagerModules.default
  ];

  programs.git = {
    enable = true;
    settings.user.email = "ivanlxy123@gmail.com";
    settings.user.name = "SoyWater";
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
    settings.aliases = {
      co = "pr checkout";
      pv = "pr view";
    };
  };

  home.packages = with pkgs; [
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
}
