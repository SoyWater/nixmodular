{ inputs, ... }:
{
  flake.nixosModules.coreSops =
  { packages, ... }:

{
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    environment.systemPackages = [
      packages.sops
    ];

    sops = {
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      defaultSopsFile = ../../secrets.yaml;
      defaultSopsFormat = "yaml";
    };
  };
}
