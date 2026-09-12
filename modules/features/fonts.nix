{ ... }:
{
  flake.nixosModules.fonts = { pkgs, ... }: {
    fonts = {
      packages = [
        pkgs.maple-mono.NF-CN
        pkgs.nerd-fonts.fira-code
        pkgs.nerd-fonts.jetbrains-mono
      ];
      fontconfig.defaultFonts.monospace = [
        "Maple Mono NF CN"
        "FiraCode Nerd Font Mono"
        "JetBrainsMono Nerd Font Mono"
      ];
    };
  };
}
