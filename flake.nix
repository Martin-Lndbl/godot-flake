{
  description = "Godot development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ (import ./overlays.nix) ];
          };
        in
        rec {
          packages.default = packages.linux;

          packages.linux = pkgs.mkGodot {
            pname = "template";
            version = "0.1.0";
            src = ./src;
            preset = "Linux"; # You need to create this preset in godot
          };

          packages.android = pkgs.mkGodot {
            pname = "template";
            version = "0.1.0";
            src = ./src;
            preset = "Android"; # You need to create this preset in godot
          };

          devShell = pkgs.mkShell {

            buildInputs = with pkgs; [
              godot_4
            ];

            shellHook = ''
            '';
          };
        }
      );
}
