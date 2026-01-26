{
  flake.modules.nixos.baseConfig =
  { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [
      pciutils
      git 
      gnumake 
      gcc 
      curl 
      wget 
      wget2
      jq 
      yq 
      tree 
      tmux 
      btop 
      ripgrep 
      fd 

      python314 
      nodejs_24
    ];
  };
}
