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

          libs = with pkgs; [
            xorg.libXcursor
            xorg.libXinerama
            xorg.libXi
            # mesa
            libGLU
            # libglvnd
            alsa-lib
            pulseaudio
          ];

        in

        rec {
          apps.default = packages.nixos_template;
          packages.nixos_template = pkgs.mkNixosPatch {
            pname = "lin_template";
            version = "0.1.0";
            src = packages.lin_template;
          };

          packages.lin_template = pkgs.mkGodot {
            pname = "lin_template";
            version = "0.1.0";
            src = ./src;
            preset = "linux"; # You need to create this preset in godot
          };

          packages.win_template = pkgs.mkGodot {
            pname = "win_template";
            version = "0.1.0";
            src = ./src;
            preset = "windows"; # You need to create this preset in godot
          };

          packages.andr_template = pkgs.mkGodot {
            pname = "andr_template";
            version = "0.1.0";
            src = ./src;
            preset = "android"; # You need to create this preset in godot
          };

          packages.export_templates = pkgs.export_templates;
          packages.makeLibraryPath = pkgs.makeLibraryPath;

          devShell = pkgs.mkShell {

            buildInputs = with pkgs; [
              godot_4
              scons
              pkgconf
              gcc
              vulkan-tools
              vulkan-loader
            ] ++ libs;
          };
        }
      );
}
