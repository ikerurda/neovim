# Custom NeoVim config flake
This config is based upon [gako358s config](https://github.com/Gako358/neovim).

## How to use
Clone the repo and run the following from the directory:
```
nix run .#
```
or
```
nix run github:ikerurda/neovim#.
```

## How to update plugins
```
nix flake update
```

## Folder structure
```
|-[lib] -- Contains utility functions
|-[modules] -- Contains modules which are used to configure neovim
|-flake.nix -- Flake file
|-README.md -- This file
```
