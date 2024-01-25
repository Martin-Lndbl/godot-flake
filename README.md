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

### Using custom templates
There are two ways to use custom templates in the nix build process:
* If the path in your `export\_templates.cfg` points to `/nix/store` no further action is required
* If that is not the case, you can pass `exportTemplates` to `mkGodot`. This can be a derivation outputting the folder containing the templates or a path to the nix store
    * Invalid paths from `export\_templates.cfg` will be removed automatically
    * This enables building with the editor and `nix build` with the same preset but a different source for custom templates

## Get the template
* Use this GitHub template to begin your repository
* Get the template the nix way:
```
nix flake init -t github:Martin-Lndbl/godot-flake#
```

## WIP - expect breaking changes
