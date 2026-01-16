{
  flake.modules.nixos.noctalia =
  { ... }:
  {
    
  };

  flake.modules.homeManager.noctalia =
  { pkgs, inputs, ... }:
  {
    home.packages = with pkgs; [
      cliphist
      brightnessctl
    ];

    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
      
    };
  };
}
