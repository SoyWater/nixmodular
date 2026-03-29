{
  flake.modules.nixos.docker=
  { pkgs, lib, config, ... }:
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
    hardware.graphics.enable32Bit = true;
    virtualisation.docker.daemon.settings.features.cdi = true;
    virtualisation.docker.enableNvidia = true;
    # virtualisation.docker.daemon.settings = {
    #   runtimes.nvidia = {
    #     path = lib.getExe' (lib.getOutput "tools" config.hardware.nvidia-container-toolkit.package) "nvidia-container-runtime";
    #   };
    # };
  };
}
