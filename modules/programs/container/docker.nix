{
  flake.modules.nixos.docker=
  { ... }:
  {
    virtualisation.docker.enable = true;
    virtualisation.docker.autoPrune= {
      enable = true;
      dates = "weekly";
      flags = [
        "--volumes"
        "--all"
      ];
    };
    hardware.nvidia-container-toolkit.enable = true;
    virtualisation.docker.daemon.settings.features.cdi = true;
  };
}
