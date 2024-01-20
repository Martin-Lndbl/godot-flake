{ inputs, ... }:

final: _prev: {
  mkGodot = _prev.callPackage ./pkgs/mkGodot.nix { };
  export_templates = _prev.callPackage ./pkgs/export_templates.nix { };
  stable = import inputs.nixpkgs-stable {
    system = final.system;
  };
}
