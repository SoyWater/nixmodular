{ config, pkgs, ... }:

let
  username = "soywater";
in
{
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  home-manager.users.${username} = import ./home.nix { pkgs = pkgs; username = username; };
}
