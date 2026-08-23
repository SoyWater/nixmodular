{ moduleWithSystem, ... }:
{
  perSystem = { pkgs, ... }: {
    packages.sops = pkgs.symlinkJoin {
      name = "sops";
      paths = [
        pkgs.sops
      ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/sops \
          --set SOPS_AGE_SSH_PRIVATE_KEY_CMD "/run/wrappers/bin/sudo ${pkgs.coreutils}/bin/cat /etc/ssh/ssh_host_ed25519_key"
      '';
    };
  };

  flake.nixosModules.sops = moduleWithSystem ({ config, ... }: {
    environment.systemPackages = [ config.packages.sops ];
  });
}
