{
  description = "Godot development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, flake-utils}@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ (import ./overlays.nix { inherit inputs; }) ];
          };
        in
        rec {
          packages.default = packages.linux;

          packages.linux = pkgs.mkGodot {
            pname = "template";
            version = "0.1.0";
            src = ./src;
            preset = "linux"; # You need to create this preset in godot
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

            LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";

            shellHook = ''
            '';
          };
        }
      );
}
