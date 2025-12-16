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
      htop 
      btop 
      ripgrep 
      fd 
      zip 
      unzip 
      p7zip 
      python314 
      nodejs_24
    ];
  };
}
