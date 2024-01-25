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

          version = "0.1.0";

        in

        rec {
          packages.default = packages.nixos_template;

          packages.nixos_template = pkgs.mkNixosPatch {
            inherit version;
            pname = "nixos_template";
            src = packages.linux_template;
          };

          packages.linux_template = pkgs.mkGodot {
            inherit version;
            pname = "linux_template";
            src = ./src;
            preset = "linux"; # You need to create this preset in godot
          };

          packages.windows_template = pkgs.mkGodot {
            inherit version;
            pname = "windows_template";
            src = ./src;
            preset = "windows"; # You need to create this preset in godot
          };

          packages.export_templates = pkgs.export_templates;

          devShell = pkgs.mkShell {

            buildInputs = with pkgs; [
              godot_4
            ];
          };
        }
      );
}
