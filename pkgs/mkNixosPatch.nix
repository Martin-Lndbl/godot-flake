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

    platform=$(awk -F'=' '
        $1 == "name" && $2 == "\"${preset}\"" {
            getline;
            if ($1 == "platform") {
                gsub(/"/, "", $2);
                print $2;
                exit;
            }
        }' export_presets.cfg)


    mkdir -p $out/bin
    ln -s $out/share/${pname}/${pname} $out/bin

    if [ "$platform" == "Linux/X11" ]; then
      patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 \
        $out/share/${pname}/${pname}
   fi

    runHook postInstall
  '';
}
