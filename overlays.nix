{ inputs, ... }:

final: _prev: {
  mkGodot = _prev.callPackage ./pkgs/mkGodot.nix { };
  stable = import inputs.nixpkgs-stable {
    system = final.system;
  };
}
