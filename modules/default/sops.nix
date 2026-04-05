
{
  flake.modules.nixos.baseConfig =
  { inputs, pkgs, ... }:

{
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    environment.systemPackages = with pkgs; [
      sops
    ];

    sops = {
      age.keyFile = "/var/lib/sops-nix/keys.txt";
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
    };
  };
}
