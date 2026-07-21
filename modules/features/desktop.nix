{
  flake.modules.nixos.desktop =
    { inputs, lib, packages, pkgs, ... }:
    let
      niriGpuSelector = pkgs.writeShellApplication {
        name = "niri-gpu-selector";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          connector_status_file=/sys/class/drm/card0-HDMI-A-1/status
          config_directory="$HOME/.config/niri"
          config_file="$config_directory/gpu.kdl"

          if [ -r "$connector_status_file" ] && [ "$(tr -d '[:space:]' < "$connector_status_file")" = connected ]; then
            selected_gpu=nvidia
            render_device=/dev/dri/by-path/pci-0000:02:00.0-render
          else
            selected_gpu=intel
            render_device=/dev/dri/by-path/pci-0000:00:02.0-render
          fi

          mkdir -p "$config_directory"
          temporary_config=$(mktemp "$config_directory/.gpu.kdl.XXXXXX")
          trap 'rm -f "$temporary_config"' EXIT
          printf 'debug {\n    render-drm-device "%s"\n}\n' "$render_device" > "$temporary_config"
          mv -f "$temporary_config" "$config_file"
          trap - EXIT

          printf 'niri-gpu-selector: HDMI-A-1 is %s; selected %s (%s)\n' \
            "$(tr -d '[:space:]' < "$connector_status_file" 2>/dev/null || printf 'unknown')" \
            "$selected_gpu" \
            "$render_device"
        '';
      };
    in
    {
      systemd.user.services.niri-gpu-selector = {
        before = [ "niri.service" ];
        wantedBy = [ "niri.service" ];
        serviceConfig.Type = "oneshot";
        script = "${niriGpuSelector}/bin/niri-gpu-selector";
      };

      imports = [ inputs.noctalia-greeter.nixosModules.default ];

      environment = {
        pathsToLink = [ "/share/wayland-sessions" ];
        systemPackages = [
          packages.desktop
          pkgs.bibata-cursors
        ];
        sessionVariables = {
          XCURSOR_THEME = "Bibata-Modern-Ice";
          XCURSOR_SIZE = "24";
          XCURSOR_PATH = lib.mkAfter [ "${pkgs.bibata-cursors}/share/icons" ];
        };
      };

      services.gnome.gnome-keyring.enable = true;

      hardware.logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
          xdg-desktop-portal-termfilechooser
        ];
        config.niri = {
          default = [ "gtk" "gnome" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        };
      };

      programs.noctalia-greeter = {
        enable = true;
        settings = {
          session.default = "niri";
          user.default = "soywater";
          cursor = {
            theme = "Bibata-Modern-Ice";
            size = 24;
            path = "${pkgs.bibata-cursors}/share/icons";
          };
        };
      };
    };
}
