{
  flake.modules.nixos.docker=
  { ... }:
  {
    virtualisation.docker.enable = true;
    virtualisation.docker.autoPrune= {
      enable = true;
      dates = "monthly";
    };
  };
}
