{
  flake.modules.homeManager.frankenstein=
  { ... }:
  {
    services.swaync.enable = true;
  };
}
