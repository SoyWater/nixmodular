
let
  username = "soywater";
in
{
  flake.modules.nixos.${username} =
  { pkgs, ... }:
  {
    users.users.${username} = {
      isNormalUser = true;
      initialPassword = "password";
      description = username;
      extraGroups = [ "greeter" "networkmanager" "wheel" "docker" "libvirtd" "wireshark" "video" "render" ];
      packages = with pkgs; [];
      useDefaultShell = true;
    };


    home-manager.users.${username} = {
      home.username = username;
      home.homeDirectory = "/home/" + username;
      home.stateVersion = "25.05";
 
      programs.git = {
        enable = true;
        lfs.enable = true;
        settings.user.email = "ivanlxy123@gmail.com";
        settings.user.name = "SoyWater";
        settings.init.defaultBranch = "main";
      };

      programs.gh = {
        enable = true;
        settings.git_protocol = "ssh";
        settings.aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };

      programs.home-manager.enable = true;
      home.enableNixpkgsReleaseCheck = false;
    };
  };
}
