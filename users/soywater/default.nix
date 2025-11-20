{ config, pkgs, inputs, ... }:

let
  username = "soywater";
in
{
  sops.secrets."${username}_hashed_password".neededForUsers = true;

  users.users.${username} = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."${username}_hashed_password".path;
    description = username;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    useDefaultShell = true;
  };


  home-manager.users.${username} = import ./home.nix { pkgs = pkgs; username = username; inputs = inputs; };
}
