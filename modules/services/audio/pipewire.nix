{
  flake.modules.nixos.pipewire =
  { pkgs, ... }:
  {
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true; # if not already enabled
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # If you want to use JACK applications, uncomment the following
      #jack.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
    
  };
}
