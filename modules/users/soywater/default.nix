
let
  username = "soywater";
in
{
  flake.modules.nixos.${username} =
  { pkgs, ... }:
  {
    users.users.${username} = {
      isNormalUser = true;
      description = username;
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [];
      useDefaultShell = true;
    };


    home-manager.users.${username} = {
      home.username = username;
      home.homeDirectory = "/home/" + username;
      home.stateVersion = "25.05";
 
      imports = [
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
    };
  };
}
