let
  moduleName = "cloudflared";
in
{
  flake.modules.nixos.${moduleName}=
  { pkgs, config, ... }:
  {
    users.users.cloudflared = {
      group = "cloudflared";
      isSystemUser = true;
    };
    users.groups.cloudflared = {};

    sops.secrets."cloudflared/cert.pem" = {
      owner = "cloudflared";
      group = "cloudflared";
    };
    sops.secrets."cloudflared/legion" = {
      owner = "cloudflared";
      group = "cloudflared";
    };

    services.cloudflared = {
      enable = true;
      certificateFile = "${config.sops.secrets."cloudflared/cert.pem".path}";
      tunnels = {
        "0c6e7882-142f-42e7-8633-bc04fc4ee968" = {
          credentialsFile = "${config.sops.secrets."cloudflared/legion".path}";
          default = "http_status:404";
        };
        
      };
    };
    environment.systemPackages = with pkgs; [
    ];

    imports = [
    ];
  };

  flake.modules.homeManager.${moduleName} =
  { pkgs, ... }:
  {
    home.packages = with pkgs; [
    ];

    imports = [
    ];
  };
}
