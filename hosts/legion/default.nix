{ config, ... }:

{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
