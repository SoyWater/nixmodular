{
  flake.modules.nixos.niri =
  { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
    programs.niri.enable = true;
    programs.niri.useNautilus = false;
    xdg.portal.config.niri."org.freedesktop.impl.portal.FileChooser" = "gnome";
  
    services.greetd =
    let
      session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "soywater";
      };
    in
    {
      enable = true;
      settings = {
        default_session = session;
        initial_session = session;
      };
    };
    services.displayManager.autoLogin = {
      enable = true;
      user = "soywater";
    };
  };

  flake.modules.homeManager.niri =
  { config, ... }:
  {
    xdg.configFile."niri".source = (config.lib.my.setupSymlinkRel ./niri);
    xdg.configFile."niri".recursive = true;
  };
}
