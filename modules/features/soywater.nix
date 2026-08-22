
let
  username = "soywater";
in
{
  flake.nixosModules.${username} =
  { pkgs, ... }:
  {
    users.users.${username} = {
      isNormalUser = true;
      hashedPassword = "$6$J88TmSWqq8YEMo.Y$e965ncDYBEWtQyzExyd0DQHOBaroGGr2CkOsb1MGrvuoQwhMIrfy4/LGpBFIGa6by08nSBhugWxt2LiHHR8ZV1";
      description = username;
      extraGroups = [ "greeter" "networkmanager" "wheel" "docker" "libvirtd" "video" "render" ];
      useDefaultShell = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO74viF4tK+qO+XiKKTp3IxqBjiZtc7udYJWsEY3qcNw soywater@legion"
      ];
    };

    programs.git = {
      enable = true;
      lfs.enable = true;
      config = {
        user.email = "ivanlxy123@gmail.com";
        user.name = "SoyWater";
        init.defaultBranch = "main";
      };
    };

    system.activationScripts."${username}-gh-config".text = ''
      install -d -m 0700 -o ${username} -g users /home/${username}/.config/gh
      install -m 0600 -o ${username} -g users \
        ${pkgs.writeText "${username}-gh-config.yml" ''
          git_protocol: ssh
          aliases:
            co: pr checkout
            pv: pr view
        ''} \
        /home/${username}/.config/gh/config.yml
    '';
  };
}
