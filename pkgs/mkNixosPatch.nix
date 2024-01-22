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
, installShellFiles
, autoPatchelfHook
, libGL
, libxkbcommon
, alsa-lib
, mkGodot
}:

{ pname
, version
, src
, preset
, desktopItems ? [ ]
}:

let
  app = mkGodot {
    inherit pname version src preset desktopItems;
  };
in

stdenv.mkDerivation rec {
  inherit pname version src desktopItems;

  nativeBuildInputs = [
    autoPatchelfHook
    installShellFiles
    copyDesktopItems
  ];

  runtimeDependencies = [
    vulkan-loader
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXext
    xorg.libXrandr
    xorg.libXrender
    xorg.libXi
    xorg.libXfixes
    libxkbcommon
    alsa-lib
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r ${app}/* $out

    runHook postInstall
  '';
}
