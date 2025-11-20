# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, host, ... }:

let
  users = [
    "soywater"
  ];
in 
{
  imports = map (user: ../../users/${user}) users;

  services.getty.autologinUser = "soywater";

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  services.tailscale.enable = true;

  services.tlp.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
