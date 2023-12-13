{ lib
, copyDesktopItems
, fetchFromGitHub
, makeDesktopItem
, stdenv
, alsa-lib
, gcc-unwrapped
, git
, godot_4
, libGLU
, libX11
, libXcursor
, libXext
, libXfixes
, libXi
, libXinerama
, libXrandr
, libXrender
, libglvnd
, libpulseaudio
, perl
, zlib
, udev # for libudev
}:

{ pname
, version
, src
, desktopItems ? [ ]
, preset
}:

stdenv.mkDerivation rec {
  inherit pname version src desktopItems;

  nativeBuildInputs = [
    copyDesktopItems
    godot_4
  ];

  buildInputs = [
    alsa-lib
    gcc-unwrapped.lib
    git
    libGLU
    libX11
    libXcursor
    libXext
    libXfixes
    libXi
    libXinerama
    libXrandr
    libXrender
    libglvnd
    libpulseaudio
    perl
    zlib
    udev
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR

    mkdir -p $out/share/${pname}
    godot4 --export-release "${preset}" $out/share/${pname}/${pname}

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
