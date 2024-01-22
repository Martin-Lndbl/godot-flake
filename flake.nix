{
  description = "Godot development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, flake-utils }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ (import ./overlays.nix { inherit inputs; }) ];
          };
        in

        rec {
          packages.default = packages.nixos_template;

          packages.nixos_template = pkgs.mkNixosPatch {
            pname = "nixos_template";
            version = "0.1.0";
            src = ./src;
            preset = "linux";
          };

          packages.linux_template = pkgs.mkGodot {
            pname = "linux_template";
            version = "0.1.0";
            src = ./src;
            preset = "linux"; # You need to create this preset in godot
          };

          packages.windows_template = pkgs.mkGodot {
            pname = "windows_template";
            version = "0.1.0";
            src = ./src;
            preset = "windows"; # You need to create this preset in godot
          };

          packages.android_template = pkgs.mkGodot {
            pname = "android_template";
            version = "0.1.0";
            src = ./src;
            preset = "android"; # You need to create this preset in godot
          };

          packages.export_templates = pkgs.export_templates;
          packages.makeLibraryPath = pkgs.makeLibraryPath;

          devShell = pkgs.mkShell {

            buildInputs = with pkgs; [
              godot_4
            ];
          };
        }
      );
}
