
let
  username = "soywater";
in
{
  flake.modules.nixos.${username} =
  { pkgs, ... }:
  {
    users.users.${username} = {
      isNormalUser = true;
      hashedPassword = "$6$J88TmSWqq8YEMo.Y$e965ncDYBEWtQyzExyd0DQHOBaroGGr2CkOsb1MGrvuoQwhMIrfy4/LGpBFIGa6by08nSBhugWxt2LiHHR8ZV1";
      description = username;
      extraGroups = [ "greeter" "networkmanager" "wheel" "docker" "libvirtd" "video" "render" ];
      packages = with pkgs; [];
      useDefaultShell = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO74viF4tK+qO+XiKKTp3IxqBjiZtc7udYJWsEY3qcNw soywater@legion"
      ];
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
