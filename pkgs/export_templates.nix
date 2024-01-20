{ fetchurl
, runCommandCC
, unzip
}:

let
  templates = fetchurl {
    url = "https://github.com/godotengine/godot/releases/download/4.2.1-stable/Godot_v4.2.1-stable_export_templates.tpz";
    hash = "sha256-xfFA61eEY6L6FAfzXjfBeqNKS4R7nTDinDhHuV5t2gc=";
  };
in

runCommandCC "build-export-templates"
{
  buildInputs = [ unzip ];
} ''
  unzip -j ${templates} -d $out

  interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)
  patchelf --set-interpreter $interpreter $out/linux_*
''
