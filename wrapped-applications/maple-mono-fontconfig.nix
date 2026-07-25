{
  perSystem = { pkgs, ... }: {
    packages.maple-mono-fontconfig =
      pkgs.writeText "maple-mono-fontconfig" ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <dir>${pkgs.maple-mono.NF-CN}/share/fonts</dir>
        </fontconfig>
      '';
  };
}
