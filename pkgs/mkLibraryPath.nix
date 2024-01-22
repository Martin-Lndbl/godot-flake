{ lib, runCommand, xorg, libGLU, stable, ... }:

let

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
  ];
in
runCommand "mkLibraryPath"
{ }
  ''
    echo "${lib.makeLibraryPath buildInputs}" > $out
    echo "patchelf --add-needed ${xorg.libX11}/lib/libX11.so template2.x86_64;" >> $out
    echo "patchelf --add-needed ${xorg.libXcursor}/lib/libXcursor.so  template2.x86_64;" >> $out
    echo "patchelf --add-needed ${xorg.libXext}/lib/libXext.so template2.x86_64;" >> $out
    echo "patchelf --add-needed ${xorg.libXi}/lib/libXi.so template2.x86_64;" >> $out
  ''
