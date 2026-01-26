{
  lib,
  alsa-lib,
  libGL,
  libICE,
  libSM,
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXinerama,
  libXrandr,
  libpulseaudio,
  libxkbcommon,
  makeDesktopItem,
  makeWrapper,
  stdenv,
  wayland,

  writeDir,
  src,
  ...
}:
let
  desktopItem = makeDesktopItem {
    name = "factorio";
    desktopName = "Factorio";
    comment = "A game about building factories";
    exec = "factorio";
    icon = "factorio";
    categories = [ "Game" ];
    
  };

  configBaseCfg = ''
    [path]
    write-data=${writeDir}/factorio/
    [other]
    check_updates=false
  '';

  updateConfigSh = ''
    #! $SHELL
    if [[ -e ${writeDir}/factorio/config/config.ini ]]; then
      # Config file exists, but may have wrong path.
      # Try to edit it. I'm sure this is perfectly safe and will never go wrong.
      sed -i "s|^write-data=.*|write-data=${writeDir}/factorio/|" ${writeDir}/factorio/config/config.ini
    else
      # Config file does not exist. Phew.
      install -D $out/share/factorio/config-base.cfg ${writeDir}/factorio/config/config.ini
    fi
  '';

in
stdenv.mkDerivation {
  pname = "factorio-space-age";
  version = "2.0.73";
  src = src;

  preferLocalBuild = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libpulseaudio ];

  libPath = lib.makeLibraryPath [
    alsa-lib
    libGL
    libICE
    libSM
    libX11
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libpulseaudio
    libxkbcommon
    wayland
  ];

  installPhase = ''
    mkdir -p $out/{bin,share/factorio}
    cp -ar . $out/share/factorio
    ln -s $out/share/factorio/bin/x64/factorio $out/bin/factorio

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/share/factorio/bin/x64/factorio

    wrapProgram $out/bin/factorio \
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/bin:$libPath \
      --run "$out/share/factorio/update-config.sh" \
      --argv0 ""

    install -m0644 <(cat << EOF
    ${configBaseCfg}
    EOF
    ) $out/share/factorio/config-base.cfg

    install -m0755 <(cat << EOF
    ${updateConfigSh}
    EOF
    ) $out/share/factorio/update-config.sh

    sed -i "s|^config-path=.*|config-path=${writeDir}/factorio/config|" $out/share/factorio/config-path.cfg

    mkdir -p $out/share/icons/hicolor/{64x64,128x128}/apps
    cp -a data/core/graphics/factorio-icon.png $out/share/icons/hicolor/64x64/apps/factorio.png
    cp -a data/core/graphics/factorio-icon@2x.png $out/share/icons/hicolor/128x128/apps/factorio.png
    ln -s ${desktopItem}/share/applications $out/share/
  '';
}
