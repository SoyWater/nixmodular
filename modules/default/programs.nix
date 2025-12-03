{ lib, pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
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
    tuigreet
  ];

  programs.niri.enable = true;
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "soywater";
      };
    };
  };
}
