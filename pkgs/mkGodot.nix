{ lib
, copyDesktopItems
, fetchFromGitHub
, stdenv
, godot_4
, xorg
, stable
, udev
, x11vnc
, vulkan-loader
, libGLU
, export_templates
}:

{ pname
, version
, src
, desktopItems ? [ ]
, preset
, rendering-driver ? "vulkan"
}:

stdenv.mkDerivation rec {
  inherit pname version src desktopItems;

  nativeBuildInputs = [
    copyDesktopItems
    godot_4
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXi
    xorg.libXfixes
    xorg.libXrender
    stable.fontconfig # Wrong elf class 2.14.0 required
    libGLU
    export_templates
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR

    mkdir -p /build/.local/share/godot/export_templates/
    ln -s ${export_templates} /build/.local/share/godot/export_templates/4.2.1.stable

    mkdir -p $out/share/${pname}
    godot4 --headless --rendering-driver ${rendering-driver} --export-release "${preset}" $out/share/${pname}/${pname}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s $out/share/${pname}/${pname} $out/bin

    # interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)
    # patchelf \
    #   --set-interpreter $interpreter \
    #   --set-rpath ${lib.makeLibraryPath buildInputs} \
    #   $out/share/${pname}/${pname}

    #   patchelf --add-needed ${xorg.libX11}/lib/libX11.so $out/share/${pname}/${pname}
    #   patchelf --add-needed ${xorg.libXcursor}/lib/libXcursor.so $out/share/${pname}/${pname}
    #   patchelf --add-needed ${xorg.libXext}/lib/libXext.so $out/share/${pname}/${pname}
    #   patchelf --add-needed ${xorg.libXi}/lib/libXi.so $out/share/${pname}/${pname}

    runHook postInstall
  '';
}
