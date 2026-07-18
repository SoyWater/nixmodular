{ config, ...}:
{
  flake.system."legion" = "x86_64-linux";
  flake.modules.nixos."hosts/legion" =
  { packages, pkgs, ... } @ nixosArgs:
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

    imports = with config.flake.modules.nixos; [
      baseConfig
      desktop
      services
      ghostty
      dualBoot
      docker
      fonts
      virtman

      # user
      soywater
    ] ++ [
      {
        home-manager.users.soywater.imports = with config.flake.modules.homeManager; [
          baseConfig
          ghostty
          direnv
        ];
      }
    ];

    # Keep the host package set aligned with the selected kernel and provide
    # the selected-kernel headers needed on Legion.
    environment.systemPackages = [
      packages.compress
      nixosArgs.config.boot.kernelPackages.kernel.dev
    ];

    nix.settings = {
      extra-substituters = [
        "https://aseipp-nix-cache.freetls.fastly.net?priority=30"
        "https://nix-community.cachix.org?priority=35"
        "https://custom-nix-applications.cachix.org?priority=40"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "custom-nix-applications.cachix.org-1:PK67OYpIq7614gth55JteSG/U2Q1DKqDAN/Wb+rEzOY="
      ];
    };

    xdg.mime.defaultApplications = {
      "application/pdf" = "zen-beta.desktop";
    };

    users.users.soywater.packages = [
      pkgs.codex
      packages.editors
      packages.factorio
      packages.gh-dash
      packages.lutris
      packages.minecraft
      packages.neovim
      packages.zen-browser-wayland
      packages.zoom
      pkgs.chromium
    ];

    # Use the newest kernel/driver pair available in the selected nixpkgs.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.kernelParams = [ "usbhid.quirks=048d:c195:0x0004" ];
    windows-boot-drive = "FS0";
    bootLoader = "limine";
    limine.secureBoot = true;

    systemd.tmpfiles.rules = [
      "w /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode - - - - 1"
    ];

    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
