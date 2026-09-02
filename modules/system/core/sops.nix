{ inputs, ... }:
{
  flake.nixosModules.coreSops =
  { pkgs, ... }:
  let
    sopsPackage = pkgs.symlinkJoin {
      name = "sops";
      paths = [ pkgs.sops ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/sops \
          --set SOPS_AGE_SSH_PRIVATE_KEY_CMD "/run/wrappers/bin/sudo ${pkgs.coreutils}/bin/cat /etc/ssh/ssh_host_ed25519_key"
      '';
    };
  in
  {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    environment.systemPackages = [
      sopsPackage
    ];

    sops = {
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      defaultSopsFile = ../../secrets.yaml;
      defaultSopsFormat = "yaml";
    };
  };
}
