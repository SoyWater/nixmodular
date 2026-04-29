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
      enableCalendarEvents = false;
      enableClipboardPaste = false;
      enableVPN = false;

      greeter = {
        enable = true;
        compositor.name = "niri";
        configHome = "/home/soywater";
      };
    };
    services.upower.enable = lib.mkDefault true;
    nix.settings = {
      extra-substituters = [
        "https://vicinae.cachix.org"
      ];
      extra-trusted-public-keys = [
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      ];
    };
  };

  flake.modules.homeManager.dms =
  { config, inputs, lib, pkgs, ... }:
  {
    imports = [
      inputs.dms.homeModules.dank-material-shell
      inputs.dms-plugin-registry.modules.default
      inputs.vicinae.homeManagerModules.default
    ];

    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;
      enableCalendarEvents = false;
      enableClipboardPaste = false;
      enableVPN = false;
      plugins = {
        displayMirror.enable = true;
        screenRecorder.enable = true;
        usbManager.enable = true;
      };
    };

    services.vicinae = {
      enable = true;
      systemd = {
        enable = true;
        autoStart = true;
        environment = {
          USE_LAYER_SHELL = "1";
        };
      };
      settings = {
        close_on_focus_loss = true;
        consider_preedit = true;
        favorites = [ "clipboard:history" ];
        pop_to_root_on_close = true;
        providers."@knoopx/vicinae-extension-firefox-0".preferences.profile_dir = ".zen/";
        search_files_in_root = true;
        launcher_window = {
          opacity = 0.98;
        };
      };
      extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        firefox
        nix
      ];
    };

    home.packages = with pkgs; [
      adw-gtk3
      capitaine-cursors
      phinger-cursors
      vanilla-dmz
      whitesur-cursors
      wl-mirror
      gpu-screen-recorder
      udisks2
      parted
      dosfstools
      e2fsprogs
      exfatprogs
    ];

    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
      dotIcons.enable = false;
    };

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

    xdg.configFile."matugen/templates/vicinae.toml".source =
      config.lib.my.setupSymlinkRel ./matugen/templates/vicinae.toml;

    xdg.configFile."matugen/templates/helix.toml".source =
      config.lib.my.setupSymlinkRel ./matugen/templates/helix.toml;

    xdg.configFile."gtk-3.0/gtk.css".text = ''
      @import url("dank-colors.css");
    '';
    xdg.configFile."gtk-3.0/gtk.css".force = true;

    xdg.configFile."gtk-4.0/gtk.css".text = ''
      @import url("dank-colors.css");
    '';
    xdg.configFile."gtk-4.0/gtk.css".force = true;

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

    home.activation.linkZenDmsTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      zen_css="${config.xdg.configHome}/DankMaterialShell/zen.css"

      for profile_dir in \
        "$(${pkgs.findutils}/bin/find "${config.home.homeDirectory}/.zen" -maxdepth 1 -type d -name "*.Default Profile" 2>/dev/null | ${pkgs.coreutils}/bin/head -n 1)" \
        "$(${pkgs.findutils}/bin/find "${config.xdg.configHome}/zen" -maxdepth 1 -type d -name "*Default (release)" 2>/dev/null | ${pkgs.coreutils}/bin/head -n 1)" \
        "$(${pkgs.findutils}/bin/find "${config.home.homeDirectory}/.var/app/app.zen_browser.zen/.zen" -maxdepth 1 -type d -name "*Default (release)" 2>/dev/null | ${pkgs.coreutils}/bin/head -n 1)"
      do
        [ -z "$profile_dir" ] && continue
        ${pkgs.coreutils}/bin/mkdir -p "$profile_dir/chrome"
        ${pkgs.coreutils}/bin/ln -sfn "$zen_css" "$profile_dir/chrome/userChrome.css"
      done
    '';

    xdg.configFile."niri/dms".source = config.lib.my.setupSymlinkRel ./config;
    xdg.configFile."niri/dms".recursive = true;
  };
}
