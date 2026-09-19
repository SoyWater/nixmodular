{ moduleWithSystem, inputs, ... }:
{
  flake.nixosModules.vicinae =
    { config, ... }:
    {
      imports = [
        (moduleWithSystem (
          { pkgs, ... }:
          let
            vicinaePackage = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.with-soulver;
          in
          {
            imports = [
              ./vicinae-module
            ];

            services.vicinae = {
              enable = true;
              package = vicinaePackage;
            };

            environment = {
              sessionVariables.LAUNCH_LAUNCHER = "vicinae toggle";
              sessionVariables.LAUNCH_CLIPBOARD = "vicinae vicinae://launch/clipboard/history?toggle=true";
            };
          }
        ))
      ];

      services.vicinae.settingsDir = "${config.settingsDir}/vicinae";
    };
}
