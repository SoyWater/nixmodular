{
  flake.modules.nixos.baseConfig =
  { pkgs, ... }:
  {
    time.timeZone = "Asia/Singapore";

    i18n.defaultLocale = "en_SG.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_SG.UTF-8";
      LC_IDENTIFICATION = "en_SG.UTF-8";
      LC_MEASUREMENT = "en_SG.UTF-8";
      LC_MONETARY = "en_SG.UTF-8";
      LC_NAME = "en_SG.UTF-8";
      LC_NUMERIC = "en_SG.UTF-8";
      LC_PAPER = "en_SG.UTF-8";
      LC_TELEPHONE = "en_SG.UTF-8";
      LC_TIME = "en_SG.UTF-8";
    };

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          qt6Packages.fcitx5-chinese-addons
        ];
      };
    };

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
