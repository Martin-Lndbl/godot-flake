{ lib
, stdenv
, mkGodot
, copyDesktopItems
, installShellFiles
, autoPatchelfHook
, xorg
, vulkan-loader
, libGL
, libxkbcommon
, alsa-lib
}:

{ pname
, version
, src
, preset
, desktopItems ? [ ]
}:

let
  app = mkGodot { # TODO: This should be the same as the linux target
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
