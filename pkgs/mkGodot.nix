{ lib
, copyDesktopItems
, fetchFromGitHub
, stdenv
, godot_4
, xorg
, stable
, udev
, x11vnc
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
    stable.fontconfig # Wrong elf class 2.14.0 required
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR

    mkdir -p $out/share/${pname}
    godot4 --rendering-driver ${rendering-driver} --export-release "${preset}" $out/share/${pname}/${pname}

    echo $DISPLAY > $out/txt

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s $out/share/${pname}/${pname} $out/bin

    interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)
    patchelf \
      --set-interpreter $interpreter \
      --set-rpath ${lib.makeLibraryPath buildInputs} \
      $out/share/${pname}/${pname}

    runHook postInstall
  '';
}
