{ ... }:
{
  flake.nixosModules.runtime = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      zlib
      openssl
      stdenv.cc.cc
      expat
    ];
  };
}
