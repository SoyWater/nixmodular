{
  flake.nixosModules.legionHardware =
  { config, lib, pkgs, ... }:
  {
    nixpkgs.hostPlatform = "x86_64-linux";

    windows-boot-drive = "FS0";

    environment.systemPackages = [
      config.boot.kernelPackages.kernel.dev
    ];

    boot = {
      initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      initrd.kernelModules = [ "i915" ];
      kernelModules = [ "kvm-intel" "mt7925e" ];
      extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = [ "usbhid.quirks=048d:c195:0x0004" ];
      extraModprobeConfig = ''
        options snd-hda-intel model=auto
      '';
      blacklistedKernelModules = [ "snd_soc_avs" ];
    };

    systemd.tmpfiles.rules = [
      "w /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode - - - - 1"
    ];

    fileSystems."/" ={
      device = "/dev/disk/by-uuid/f129f428-794b-4ef2-a341-a0bde5095f76";
      fsType = "ext4";
    };

    fileSystems."/boot" ={
      device = "/dev/disk/by-uuid/7D8E-D3EC";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    swapDevices = [ ];

    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
      (intel-vaapi-driver.override { enableHybridCodec = false; })
      intel-ocl
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        (intel-vaapi-driver.override { enableHybridCodec = false; })
        intel-media-driver
      ];
    };
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      prime = {
        intelBusId = "PCI:00:02:0";
        nvidiaBusId = "PCI:02:00:0";
        offload.enable = true;
        offload.enableOffloadCmd = true;
      };
    };

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
