{ moduleWithSystem, inputs, ... }:
{
  flake.nixosModules.niri = moduleWithSystem (
    { self', pkgs, ... }: {
      environment.systemPackages = [ self'.packages.niri ];
    }
  );

  perSystem = { lib, pkgs, self', ... }: {
    packages.niri = inputs.wrappers.wrappers.niri.wrap {
      inherit pkgs;
      imports = [
        ./gpu-selector-module
      ];
      runtimePkgs = [ pkgs.xwayland-satellite ];
      env = {
        EDITOR = "hx";
        VISUAL = "hx";
        XCURSOR_THEME = "Bibata-Modern-Ice";
        XCURSOR_SIZE = "24";
        XCURSOR_PATH = "${pkgs.bibata-cursors}/share/icons";
      };
      settings.binds = {
        "Mod+Shift+Slash".show-hotkey-overlay = _: { };

        "Mod+T" = _: { props.hotkey-overlay-title = "Open a Terminal: kitty"; content.spawn = lib.getExe self'.packages.kitty; };
        "Mod+B" = _: { props.hotkey-overlay-title = "Open Zen Browser"; content.spawn = lib.getExe' self'.packages.zen-browser-wayland "zen-beta"; };

        XF86AudioRaiseVolume = _: { props.allow-when-locked = true; content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; };
        XF86AudioLowerVolume = _: { props.allow-when-locked = true; content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; };
        XF86AudioMute = _: { props.allow-when-locked = true; content.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; };
        XF86AudioMicMute = _: { props.allow-when-locked = true; content.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; };
        XF86AudioPlay = _: { props.allow-when-locked = true; content.spawn-sh = "playerctl play-pause"; };
        XF86AudioStop = _: { props.allow-when-locked = true; content.spawn-sh = "playerctl stop"; };
        XF86AudioPrev = _: { props.allow-when-locked = true; content.spawn-sh = "playerctl previous"; };
        XF86AudioNext = _: { props.allow-when-locked = true; content.spawn-sh = "playerctl next"; };

        "Mod+Shift+P".power-off-monitors = _: { };
        "Mod+Ctrl+0".spawn-sh = "niri msg outputs | ${lib.getExe' pkgs.gnugrep "grep"} -n2 eDP | ${lib.getExe' pkgs.gnugrep "grep"} Disabled -q && { niri msg output eDP-1 on; } || { niri msg output eDP-1 off; }";
        "Mod+O" = _: { props.repeat = false; content.toggle-overview = _: { }; };
        "Mod+Q" = _: { props.repeat = false; content.close-window = _: { }; };
        "Mod+Ctrl+Shift+Q" = _: { props.hotkey-overlay-title = "Force Kill Picked Window"; content.spawn-sh = "kill -9 $(niri msg --json pick-window 2>/dev/null | ${lib.getExe pkgs.jq} .pid)"; };

        "Mod+Left".focus-column-left = _: { };
        "Mod+Down".focus-window-down = _: { };
        "Mod+Up".focus-window-up = _: { };
        "Mod+Right".focus-column-right = _: { };
        "Mod+H".focus-column-left = _: { };
        "Mod+L".focus-column-right = _: { };
        "Mod+Ctrl+Left".move-column-left = _: { };
        "Mod+Ctrl+Down".move-window-down = _: { };
        "Mod+Ctrl+Up".move-window-up = _: { };
        "Mod+Ctrl+Right".move-column-right = _: { };
        "Mod+Ctrl+H".move-column-left = _: { };
        "Mod+Ctrl+L".move-column-right = _: { };
        "Mod+Ctrl+P".spawn-sh = "niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | ${lib.getExe pkgs.jq} .id)";

        "Mod+Home".focus-column-first = _: { };
        "Mod+End".focus-column-last = _: { };
        "Mod+Ctrl+Home".move-column-to-first = _: { };
        "Mod+Ctrl+End".move-column-to-last = _: { };

        "Mod+Shift+Left".focus-monitor-left = _: { };
        "Mod+Shift+Down".focus-monitor-down = _: { };
        "Mod+Shift+Up".focus-monitor-up = _: { };
        "Mod+Shift+Right".focus-monitor-right = _: { };
        "Mod+Shift+H".focus-monitor-left = _: { };
        "Mod+Shift+J".focus-monitor-down = _: { };
        "Mod+Shift+K".focus-monitor-up = _: { };
        "Mod+Shift+L".focus-monitor-right = _: { };
        "Mod+Shift+Ctrl+Left".move-window-to-monitor-left = _: { };
        "Mod+Shift+Ctrl+Down".move-window-to-monitor-down = _: { };
        "Mod+Shift+Ctrl+Up".move-window-to-monitor-up = _: { };
        "Mod+Shift+Ctrl+Right".move-window-to-monitor-right = _: { };
        "Mod+Shift+Ctrl+H".move-window-to-monitor-left = _: { };
        "Mod+Shift+Ctrl+J".move-window-to-monitor-down = _: { };
        "Mod+Shift+Ctrl+K".move-window-to-monitor-up = _: { };
        "Mod+Shift+Ctrl+L".move-window-to-monitor-right = _: { };

        "Mod+Page_Down".focus-workspace-down = _: { };
        "Mod+Page_Up".focus-workspace-up = _: { };
        "Mod+J".focus-workspace-down = _: { };
        "Mod+K".focus-workspace-up = _: { };
        "Mod+Ctrl+Page_Down".move-window-to-workspace-down = _: { };
        "Mod+Ctrl+Page_Up".move-window-to-workspace-up = _: { };
        "Mod+Ctrl+J".move-window-to-workspace-down = _: { };
        "Mod+Ctrl+K".move-window-to-workspace-up = _: { };
        "Mod+Shift+Page_Down".move-workspace-down = _: { };
        "Mod+Shift+Page_Up".move-workspace-up = _: { };
        "Mod+Shift+U".move-workspace-down = _: { };
        "Mod+Shift+I".move-workspace-up = _: { };

        "Mod+WheelScrollDown" = _: { props.cooldown-ms = 150; content.focus-workspace-down = _: { }; };
        "Mod+WheelScrollUp" = _: { props.cooldown-ms = 150; content.focus-workspace-up = _: { }; };
        "Mod+Ctrl+WheelScrollDown" = _: { props.cooldown-ms = 150; content.move-column-to-workspace-down = _: { }; };
        "Mod+Ctrl+WheelScrollUp" = _: { props.cooldown-ms = 150; content.move-column-to-workspace-up = _: { }; };
        "Mod+WheelScrollRight".focus-column-right = _: { };
        "Mod+WheelScrollLeft".focus-column-left = _: { };
        "Mod+Ctrl+WheelScrollRight".move-column-right = _: { };
        "Mod+Ctrl+WheelScrollLeft".move-column-left = _: { };
        "Mod+Shift+WheelScrollDown".focus-column-right = _: { };
        "Mod+Shift+WheelScrollUp".focus-column-left = _: { };
        "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = _: { };
        "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = _: { };

        "Mod+Z".focus-workspace = 1;
        "Mod+X".focus-workspace = 2;
        "Mod+C".focus-workspace = 3;
        "Mod+1".focus-workspace = 4;
        "Mod+2".focus-workspace = 5;
        "Mod+3".focus-workspace = 6;
        "Mod+4".focus-workspace = 7;
        "Mod+5".focus-workspace = 8;
        "Mod+6".focus-workspace = 9;
        "Mod+Ctrl+Z".move-window-to-workspace = 1;
        "Mod+Ctrl+X".move-window-to-workspace = 2;
        "Mod+Ctrl+C".move-window-to-workspace = 3;
        "Mod+Ctrl+1".move-window-to-workspace = 4;
        "Mod+Ctrl+2".move-window-to-workspace = 5;
        "Mod+Ctrl+3".move-window-to-workspace = 6;
        "Mod+Ctrl+4".move-window-to-workspace = 7;
        "Mod+Ctrl+5".move-window-to-workspace = 8;
        "Mod+Ctrl+6".move-window-to-workspace = 9;

        "Mod+Ctrl+R".reset-window-height = _: { };
        "Mod+F".maximize-column = _: { };
        "Mod+Shift+F".fullscreen-window = _: { };
        "Mod+Ctrl+F".expand-column-to-available-width = _: { };
        "Mod+Minus".set-column-width = "-10%";
        "Mod+Equal".set-column-width = "+10%";
        "Mod+Shift+Minus".set-window-height = "-10%";
        "Mod+Shift+Equal".set-window-height = "+10%";
        "Mod+W".toggle-column-tabbed-display = _: { };
        Print.screenshot = _: { };
        "Ctrl+Print".screenshot-screen = _: { };
        "Alt+Print".screenshot-window = _: { };
        "Mod+Escape" = _: { props.allow-inhibiting = false; content.toggle-keyboard-shortcuts-inhibit = _: { }; };
        "Ctrl+Alt+Delete".quit = _: { };
      };
      settings.spawn-at-startup = [
        [
          (lib.getExe self'.packages.vicinae)
          "server"
          "--config"
          "/home/soywater/nixconfigs/modules/features/desktop/vicinae/config/settings.json"
        ]
      ];
      # The app configurations are immutable store paths; user-generated
      # Noctalia theme files remain optional at their runtime location.
      extraSettings = [
        { include = ./config/config.kdl; }
        { include = ./config/monitors.kdl; }
        { include = ./config/inputs.kdl; }
        {
          include = [
            { optional = true; }
            ./../noctalia/config/noctalia.kdl
          ];
        }
        {
          include = [
            { optional = true; }
            "/home/soywater/nixconfigs/.temp/noctalia/themes/niri/noctalia.kdl"
          ];
        }
      ];
      passthru.cargoBuildNoDefaultFeatures = pkgs.niri.cargoBuildNoDefaultFeatures;
      passthru.cargoBuildFeatures = pkgs.niri.cargoBuildFeatures;
    };
  };
}
