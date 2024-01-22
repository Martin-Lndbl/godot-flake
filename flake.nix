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
          packages.default = packages.linux;

          packages.linux = pkgs.mkGodot {
            pname = "glin";
            version = "0.1.0";
            src = ./src;
            preset = "linux"; # You need to create this preset in godot
          };

          packages.windows = pkgs.mkGodot {
            pname = "gwin";
            version = "0.1.0";
            src = ./src;
            preset = "windows"; # You need to create this preset in godot
          };

          packages.android = pkgs.mkGodot {
            pname = "template";
            version = "0.1.0";
            src = ./src;
            preset = "android"; # You need to create this preset in godot
          };

          packages.export_templates = pkgs.export_templates;
          packages.makeLibraryPath = pkgs.makeLibraryPath;

          packages.tmp = pkgs.xorg.libXinerama;

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
