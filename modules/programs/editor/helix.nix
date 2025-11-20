{ lib, pkgs, config, ... }:

{
  options = {
    helix.enable = lib.mkEnableOption {
      name = "enable helix";
      default = true;
    };
  };

  config = lib.mkIf config.helix.enable {    
    programs.helix = {
      enable = true;
      defaultEditor = true;
    };

    programs.helix.settings = {
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
        bufferline = "always";
        true-color = true;
      };

      editor.indent-guides = {
        render = true;
        character = "┊";
        skip-levels = 1;
      };

      keys.normal.space.l = ":toggle lsp.display-inlay-hints";
      
      editor.statusline = {
        left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
        right = [ "version-control" "diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type" ];
        separator = "│";
      };
    };

    home.packages = with pkgs; [
      nixd
    ];

    programs.helix.languages = {
      language-server.nixd = {
        command = "${pkgs.nixd}/bin/nixd";
      };
           
      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nixd" ];
        }
      ];
    };
  };
}
