{ inputs, ... }:

final: _prev: {
  mkGodot = _prev.callPackage ./pkgs/mkGodot.nix { };
  mkNixosPatch = _prev.callPackage ./pkgs/mkNixosPatch.nix { };
  export_templates = _prev.callPackage ./pkgs/export_templates.nix { };
}
