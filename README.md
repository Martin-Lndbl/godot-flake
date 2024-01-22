# godot-flake
An easy to use flake template to develop your first game with godot

## WIP - Currently not working
* Building for windows with `nix build .#windows` works
* Building for windows from editor works
* Building for linux with `nix build .#linux` works
* Building for linux from editor works
* Building for nixos doesn't work

## Problems for NixOs patch
* Putting `/nix/store/qs1llsl5x27d9fhgzrhdfypn146z52xd-libXi-1.8.1/lib` in executables rpath will cause a segmentation fault
```
ERROR: Can't load Xinput2 dynamically.
   at: DisplayServerX11 (platform/linuxbsd/x11/display_server_x11.cpp:5765)
```
