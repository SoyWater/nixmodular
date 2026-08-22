{ ... }:
{
  flake.nixosModules.terminal =
    { config, packages, ... }:
    let
      terminalConfigHome = "${config.users.users.soywater.home}/nixconfigs";
      terminalPackage = packages.terminal.wrap {
        _module.args.terminalConfigHome = terminalConfigHome;
      };
    in
    {
      # Use the composed Fish wrapper for every login session.  Its --no-config
      # boundary keeps terminal configuration owned by wrapped-applications.
      environment.systemPackages = [ terminalPackage ];
      users.users.soywater.shell = terminalPackage;
    };
}
