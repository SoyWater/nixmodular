{
  flake.modules.nixos.dms =
  { inputs, lib, ... }:
  {
    imports = [
      inputs.dms.nixosModules.dank-material-shell
      inputs.dms.nixosModules.greeter
    ];

    programs.dank-material-shell = {
      enable = true;
      greeter = {
        enable = true;
        compositor.name = "niri";
        configHome = "/home/soywater";
      };
    };
    services.upower.enable = lib.mkDefault true;
  };

  flake.modules.homeManager.dms =
  { config, inputs, pkgs, ... }:
  {
    imports = [
      inputs.dms.homeModules.dank-material-shell
      inputs.dms-plugin-registry.modules.default
    ];

    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;
      plugins = {
        displayMirror.enable = true;
        screenRecorder.enable = true;
        usbManager.enable = true;
      };
    };

    home.packages = with pkgs; [
      wl-mirror
      gpu-screen-recorder
      udisks2
      parted
      dosfstools
      e2fsprogs
      exfatprogs
    ];

    xdg.configFile."fcitx5/conf/classicui.conf".source =
      config.lib.my.setupSymlinkRel ./fcitx5/conf/classicui.conf;

    xdg.configFile."matugen/config.toml".source =
      config.lib.my.setupSymlinkRel ./matugen/config.toml;

    xdg.configFile."matugen/templates/fcitx5-theme.conf".source =
      config.lib.my.setupSymlinkRel ./matugen/templates/fcitx5-theme.conf;

    xdg.configFile."matugen/templates/fcitx5-panel.svg".source =
      config.lib.my.setupSymlinkRel ./matugen/templates/fcitx5-panel.svg;

    xdg.configFile."matugen/templates/fcitx5-highlight.svg".source =
      config.lib.my.setupSymlinkRel ./matugen/templates/fcitx5-highlight.svg;

    xdg.dataFile."fcitx5/themes/dank-matugen/arrow.png".source =
      "${pkgs.fcitx5}/share/fcitx5/themes/default-dark/arrow.png";
    xdg.dataFile."fcitx5/themes/dank-matugen/next.png".source =
      "${pkgs.fcitx5}/share/fcitx5/themes/default-dark/next.png";
    xdg.dataFile."fcitx5/themes/dank-matugen/prev.png".source =
      "${pkgs.fcitx5}/share/fcitx5/themes/default-dark/prev.png";
    xdg.dataFile."fcitx5/themes/dank-matugen/radio.png".source =
      "${pkgs.fcitx5}/share/fcitx5/themes/default-dark/radio.png";

    home.file.".local/share/icons/hicolor".source =
      "${pkgs.fcitx5}/share/icons/hicolor";
    home.file.".local/share/icons/hicolor".recursive = true;

    xdg.configFile."niri/dms".source = config.lib.my.setupSymlinkRel ./config;
    xdg.configFile."niri/dms".recursive = true;
  };
}
