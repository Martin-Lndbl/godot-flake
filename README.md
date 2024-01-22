# Godot flake
An easy to use flake template for godot development and continuous integration.

## Features
* Build targets using `nix build` or the editor
* Supported targets: Linux/X11 and Windows
* Additional target to automatically patch the Linux target for NixOs

#### Development environment
* Nix devShell provides godot4 and required libraries
* Automatically start the devShell when entering the project by enabling [direnv](https://github.com/direnv/direnv)
* Use `nix run` to automatically build and run the current version of your game

#### Continuous Integration
* Use `nix build .#TARGET` to build the specified target
* This can also be done by any CI workflow
* Using `nix build` targets can be deployed automatically

## WIP - expect breaking changes
#### Currently not working:
* Using custom `export_templates`
