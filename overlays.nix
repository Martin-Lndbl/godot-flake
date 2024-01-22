{ inputs, ... }:

final: _prev: {
  mkGodot = _prev.callPackage ./pkgs/mkGodot.nix { };
  export_templates = _prev.callPackage ./pkgs/export_templates.nix { };
  makeLibraryPath = _prev.callPackage ./pkgs/mkLibraryPath.nix { };
  stable = import inputs.nixpkgs-stable {
    system = final.system;
  };
}
