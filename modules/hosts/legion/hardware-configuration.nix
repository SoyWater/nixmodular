{
  flake.modules.nixos."hosts/legion" =
  { config, lib, pkgs, ... }:
  {

    boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ "i915" ];
    boot.kernelModules = [ "kvm-intel" "mt7925e" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];

    boot.extraModprobeConfig = ''
      options snd-hda-intel model=auto
    '';
    boot.blacklistedKernelModules = [ "snd_soc_avs" ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/f129f428-794b-4ef2-a341-a0bde5095f76";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/7D8E-D3EC";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
      };

    swapDevices = [ ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp129s0.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp130s0.useDHCP = lib.mkDefault true;

    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    hardware.graphics.extraPackages = with pkgs; [
      (intel-vaapi-driver.override { enableHybridCodec = false; })
      intel-ocl
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
    hardware.graphics.extraPackages32 = with pkgs.driversi686Linux; [
      (intel-vaapi-driver.override { enableHybridCodec = false; })
      intel-media-driver
    ];

    hardware.nvidia = {
      open = lib.mkOverride 990 (
        config.hardware.nvidia.package ? open
        && config.hardware.nvidia.package ? firmware
      );
      powerManagement.enable = lib.mkDefault true;
      prime = {
        intelBusId = "PCI:00:02:0";
        nvidiaBusId = "PCI:02:00:0";
        offload = {
          enable = lib.mkOverride 990 true;
          enableOffloadCmd = true;
        };
      };
    };

    services.fstrim.enable = lib.mkDefault true;
    services.tlp.enable = lib.mkDefault (
      (lib.versionOlder (lib.versions.majorMinor lib.version) "21.05")
      || !config.services.power-profiles-daemon.enable
    );
    services.thermald.enable = lib.mkDefault true;
    services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
    services.xserver.dpi = 189;

    console.font = lib.mkIf (
      lib.versionOlder config.boot.kernelPackages.kernel.version "6.8"
    ) (
      lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz"
    );
    console.earlySetup = lib.mkIf (
      lib.versionOlder config.boot.kernelPackages.kernel.version "6.8"
    ) (lib.mkDefault true);
  };
}
