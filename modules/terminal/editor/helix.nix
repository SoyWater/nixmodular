{
  flake.modules.homeManager.baseConfig =
  { pkgs, ... }:
  let
    languages = with pkgs; [
      nixd
      gopls
      typescript-language-server
    ];
  in
  {
      programs.helix = {
        enable = true;
        defaultEditor = true;
      };

      programs.helix.settings = {
        theme = "catppuccin_mocha";
        editor = {
          mouse = false;
          line-number = "relative";
          lsp.display-messages = true;
          bufferline = "multiple";
          true-color = true;
        };

        editor.indent-guides = {
          render = true;
          character = "┊";
          skip-levels = 1;
        };

        keys.normal.space.l = ":toggle lsp.display-inlay-hints";
        keys.normal.esc = [ "collapse_selection" "keep_primary_selection" ];
      
        editor.statusline = {
          left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
          right = [ "version-control" "diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type" ];
          separator = "│";
        };

        editor.cursor-shape = {
          insert = "bar";
          select = "underline";
        };

        editor.end-of-line-diagnostics = "hint";
        editor.inline-diagnostics.cursor-line = "warning";
      };

      programs.helix.extraPackages = languages;
  };
}
