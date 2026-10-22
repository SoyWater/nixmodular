{ ... }:
{
  flake.nixosModules.media = { config, pkgs, ... }: {
    # systemd supplies Android USB uaccess rules; programs.adb was removed.
    environment.systemPackages = with pkgs; [ ffmpeg_7 scrcpy android-tools ];

    boot.kernelModules = [ "v4l2loopback" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    boot.extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="S24 Ultra Webcam" video_nr=10
    '';
  };
}
